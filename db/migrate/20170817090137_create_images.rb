class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.string :image,          null: false, default: ''
      t.integer :height,        null: false, default: 0
      t.integer :width,         null: false, default: 0
      t.references :imageable, polymorphic: true, type: :uuid, index: true

      t.timestamps
    end
  end
end
