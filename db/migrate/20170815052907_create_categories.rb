class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name,  null: false, default: ''
      t.string :image, null: false, default: ''
      t.references :super_category, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
