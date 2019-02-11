class AddEmailToSupplier < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :email, :string
  end
end
