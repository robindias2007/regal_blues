class AddSerialNumberToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :serial_number, :integer
  end
end
