class AddCatalogueProducts < ActiveRecord::Migration
  def self.up
    create_table :spree_catalogues_products, :id => false do |t|
      t.integer :catalogue_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :spree_catalogues_products
  end
end
