class CreateSuperCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :super_categories, id: :uuid do |t|
      t.string :name,  null: false, default: ''
      t.string :image, null: false, default: ''

      t.timestamps
    end
    add_index :super_categories, :name, unique: true
  end
end
