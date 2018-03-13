class AddNotesImageToOrderMeasurements < ActiveRecord::Migration[5.1]
  def change
    add_column :order_measurements, :notes, :string
    add_column :order_measurements, :image, :string
  end
end
