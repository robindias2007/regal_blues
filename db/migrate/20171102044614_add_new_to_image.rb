class AddNewToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :new, :boolean, null: false, default: false
  end
end
