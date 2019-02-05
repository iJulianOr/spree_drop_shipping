class AddEntityType < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :entity_type, :string
    rename_column :spree_stock_locations, :retailer_id, :entity_id
    add_index :spree_stock_locations, [:entity_id, :entity_type]

    Spree::StockLocation.reset_column_information
  end
end
