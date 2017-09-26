class CreateRequestImages < ActiveRecord::Migration[5.1]
  def change
    create_table :request_images, id: :uuid do |t|
      t.string :image, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :color, null: false, default: ''
      t.integer :height, null: false, default: 0
      t.integer :width, null: false, default: 0
      t.references :request, index: true, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
