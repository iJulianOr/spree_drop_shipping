class CreateSpreeSupplierImportations < ActiveRecord::Migration
  def change
    create_table :spree_supplier_importations do |t|

      t.string :status
      t.integer :supplier_id
      t.timestamps null: false
    end
  end
end
