module Spree
  module Admin
    module Suppliers
      class ImportationsController < Spree::Admin::SuppliersController
        before_filter :load_supplier, only: [:index, :update, :new]

        def index
          @collection = @supplier.importations.reverse
          respond_to do |format|
            format.html
            format.csv { send_data stocks_to_csv, filename: "#{Spree.t(:products)}-#{Time.zone.now.strftime('%d-%m-%y')}.csv" }
          end
        end

        def new
          if params[:file].to_s == ''
            flash[:error] = Spree.t('hogarnet.importations.empty_file')
            render :index
          else
            importation = @supplier.importations.create!(status: 'pending')
            file = save_file
            Object::BackendImportation.import file, importation, @supplier
            redirect_to :back
          end
        rescue StandardError => e
          importation.update_attributes! status: 'failed'
          flash[:error] = "#{e}"
          redirect_to :back
        end

        private

        def stocks_to_csv
          CSV.generate(headers: true) do |csv|
            csv << ['SKU', 'Stock']
            products = @supplier.products.joins(:master, stock_items: :stock_location).uniq.where('spree_stock_locations.id': @supplier.stock_location.id)
            products = products.pluck('spree_variants.sku', 'spree_stock_items.count_on_hand')
            products.map do |p|
              csv << p
            end
          end
        end

        def save_file
          file_name = params[:file].original_filename
          File.open("#{Rails.root}/tmp/#{file_name}", 'wb') { |f| f.write(params[:file].read) }
          File.open("#{Rails.root}/tmp/#{file_name}")
        end
      end
    end
  end
end
