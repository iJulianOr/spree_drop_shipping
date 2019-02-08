class AddEntityType < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :entity_type, :string
    if defined?(Hogarnet::Retailer)
      rename_column :spree_stock_locations, :retailer_id, :entity_id
    else
      add_column :spree_stock_locations, :entity_id, :integer
    end
    add_index :spree_stock_locations, [:entity_id, :entity_type]

    Spree::StockLocation.reset_column_information
  end
end
