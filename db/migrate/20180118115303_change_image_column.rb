class ChangeImageColumn < ActiveRecord::Migration[5.1]
  def change
	change_column :picks, :images, :string, array: true, default: [], using: "(string_to_array(images, ','))"
  end
end
