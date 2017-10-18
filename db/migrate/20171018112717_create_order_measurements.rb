class CreateOrderMeasurements < ActiveRecord::Migration[5.1]
  def change
    create_table :order_measurements, id: :uuid do |t|
      t.jsonb :data
      t.references :order, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
