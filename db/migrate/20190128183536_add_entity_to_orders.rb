class AddEntityToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :entity_type, :string
    add_column :spree_orders, :entity_id, :integer

    add_index :spree_orders, [:entity_type, :entity_id]
  end
end
