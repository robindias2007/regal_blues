class AddMeasurementImageToSubCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_categories, :measurement_image, :string
  end
end
