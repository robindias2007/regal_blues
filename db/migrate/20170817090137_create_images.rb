class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid do |t|
      t.string :image,          null: false, default: ''
      t.integer :height,        null: false, default: ''
      t.integer :width,         null: false, default: ''
      # t.string :imageable_type, null: false, default: ''
      # t.uuid :imageable_id,     null: false
      t.references :imageable, polymorphic: true, type: :uuid

      t.timestamps
    end
    # add_index :images, [:imageable_type, :imageable_id]
  end
end
