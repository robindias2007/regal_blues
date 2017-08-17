class CreateProductInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :product_infos, id: :uuid do |t|
      t.string :color, null: false, default: ''
      t.text :fabric, null: false, default: ''
      t.text :care, null: false, default: ''
      t.text :notes
      t.text :work
      t.references :product, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
