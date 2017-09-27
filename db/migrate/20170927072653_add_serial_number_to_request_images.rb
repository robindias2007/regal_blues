class AddSerialNumberToRequestImages < ActiveRecord::Migration[5.1]
  def change
    add_column :request_images, :serial_number, :integer
    add_index :request_images, :serial_number, using: :gin
  end
end
