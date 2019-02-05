class CreateSpreeSuppliers < ActiveRecord::Migration
  def change
    create_table :spree_suppliers do |t|

      t.string :name
      t.timestamps null: false
    end
  end
end
