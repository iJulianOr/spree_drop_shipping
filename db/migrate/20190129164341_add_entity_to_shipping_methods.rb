class AddEntityToShippingMethods < ActiveRecord::Migration
  def change
    add_column :spree_shipping_methods, :entity_type, :string
    add_column :spree_shipping_methods, :entity_id, :integer

    add_index :spree_shipping_methods, [:entity_type, :entity_id]
  end
end
