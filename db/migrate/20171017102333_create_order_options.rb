class CreateOrderOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :order_options, id: :uuid do |t|
      t.references :order, type: :uuid, index: true, foreign_key: true
      t.references :image, type: :uuid, index: true, foreign_key: true
      t.boolean :more_options, null: false, default: false
      t.boolean :designer_pick, null: false, default: false

      t.timestamps
    end
  end
end
