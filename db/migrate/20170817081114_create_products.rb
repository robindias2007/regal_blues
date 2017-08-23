class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name,           null: false, default: ''
      t.text :description,      null: false, default: ''
      t.decimal :selling_price, null: false, default: 0.0, precision: 12, scale: 2
      t.string :sku,            null: false, default: ''
      t.boolean :active,        null: false, default: true

      t.references :sub_category, type: :uuid, index: true, foreign_key: true
      t.references :designer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :products, :sku,           unique: true
    add_index :products, :name,          unique: :gin
    add_index :products, :selling_price, unique: :gin
    add_index :products, :active,        where: :active
  end
end
