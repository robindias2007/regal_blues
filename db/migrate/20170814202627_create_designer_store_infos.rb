class CreateDesignerStoreInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :designer_store_infos, id: :uuid do |t|
      t.string :display_name,     null: false, default: ''
      t.string :registered_name,  null: false, default: ''
      t.string :pincode,          null: false, default: ''
      t.string :country,          null: false, default: ''
      t.string :state,            null: false, default: ''
      t.string :city,             null: false, default: ''
      t.text :address_line_1,     null: false, default: ''
      t.text :address_line_2
      t.string :contact_number,   null: false, default: ''
      t.decimal :min_order_price, null: false, default: 0.0, precision: 9, scale: 2
      t.integer :processing_time,  null: false, default: 0

      t.references :designer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :designer_store_infos, :display_name,    unique: true
    add_index :designer_store_infos, :registered_name, unique: true
    add_index :designer_store_infos, :min_order_price, using: :gin
    add_index :designer_store_infos, :processing_time, using: :gin
  end
end
