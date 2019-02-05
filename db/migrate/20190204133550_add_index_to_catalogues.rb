class AddIndexToCatalogues < ActiveRecord::Migration
  def change
    add_index :spree_catalogues_products, [:catalogue_id, :product_id], unique: true
  end
end
