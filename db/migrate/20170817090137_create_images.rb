class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.string :image,          null: false, default: ''
      t.integer :height,        null: false, default: ''
      t.integer :width,         null: false, default: ''
      t.references :imageable, polymorphic: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
