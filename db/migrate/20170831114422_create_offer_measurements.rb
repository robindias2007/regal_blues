class CreateOfferMeasurements < ActiveRecord::Migration[5.1]
  def change
    create_table :offer_measurements, id: :uuid do |t|
      t.jsonb :data, null: false, default: {}
      t.references :offer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end

    add_index :offer_measurements, :data, using: :gin
  end
end
