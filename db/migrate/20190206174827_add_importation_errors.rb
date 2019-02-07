class AddImportationErrors < ActiveRecord::Migration
  def change
    add_column :spree_supplier_importations, :import_errors, :text
  end
end
