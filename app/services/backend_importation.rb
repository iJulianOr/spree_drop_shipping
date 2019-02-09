class BackendImportation
  def self.import(*args)
    new.import *args
  end

  def import(file, importation, supplier)
    @supplier = supplier
    ActiveRecord::Base.connection.disconnect!
    Thread.new do
      ActiveRecord::Base.establish_connection
      begin
        products_with_errors = process_import file, importation
        save_import_errors(importation.reload, products_with_errors)
        importation.update_attributes!(status: 'success') if importation.status == 'pending'
      rescue StandardError => e
        importation.update_attributes! status: 'failed'
      end
    end
    ActiveRecord::Base.establish_connection
  end

  def process_import(file, importation, products_with_errors = [])
    file = clean_malformed_csv(file)
    rows = CSV.parse(file, force_quotes: false)
    rows.map do |row|
      begin
        next if row.first =~ /sku/i
        import_products row, importation
      rescue Custom::Exceptions::ImportationFailed
        products_with_errors << row.first
        save_import_status(importation, 'warning')
        next
      end
    end

    products_with_errors
  end

  def import_products(row, importation)
    product = @supplier.products.joins(:master).find_by('spree_variants.sku': row.first)
    product ||= Spree::Product.joins(:master).find_by('spree_variants.sku': row.first)
    raise Custom::Exceptions::ImportationFailed unless product
    @supplier.catalogue.products << product unless @supplier.products.include? product
    product.stock_items.find_by(stock_location: @supplier.stock_location).set_count_on_hand(row.last.to_i)
    product.save!
  end

  def clean_malformed_csv(file)
    extname = File.extname(file)
    extname.match(/xls/i) ? convert_xlsx(file, extname) : clean_csv(file)
  end

  def convert_xlsx(file, extname)
    excel = extname.match(/xlsx/) ? Roo::Excelx.new(file) : Roo::Excel.new(file)
    excel = excel.to_csv
    I18n.transliterate(excel)
  end

  def clean_csv(file)
    # file = prepend_headers(file)
    file = File.read(file.path)
    file = file.encode('UTF-8', :invalid => :replace, :undef => :replace)
    cleaned_file = I18n.transliterate(file) # Clean special chars from UTF-8 encode
    cleaned_file = cleaned_file.
      gsub(/,/,'.'). # Clean comma separated strings per line
      gsub(/\;/, ',') if cleaned_file.match(/\;/) # Transform each semicolon into comma since they're the Excel's default separator
    cleaned_file.gsub(/\"/, "") # Cleans doble quoted names. E.g.: Televisor 22"
  end

  def save_import_errors(importation, errors)
    importation.import_errors = errors.join(',')
    importation.save!

    importation
  end

  def save_import_status(importation, status)
    importation.status = status unless status == 'success' && importation.status == 'warning'
    importation.save!
  end
end
