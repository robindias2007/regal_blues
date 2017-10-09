class AddDescriptionToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :description, :text
  end
end
