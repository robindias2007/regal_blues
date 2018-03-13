class AddSerialNoToSubCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_categories, :serial_no, :integer
  end
end
