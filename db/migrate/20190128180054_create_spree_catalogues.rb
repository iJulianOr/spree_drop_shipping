class CreateSpreeCatalogues < ActiveRecord::Migration
  def change
    create_table :spree_catalogues do |t|

      t.string :entity_type
      t.integer :entity_id
      t.timestamps null: false
    end
  end
end
