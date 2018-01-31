class CreateMeasurementTags < ActiveRecord::Migration[5.1]
  def change
    create_table :measurement_tags, id: :uuid do |t|
      t.string :name
      t.string :url
      t.string :measurement_type

      t.timestamps
    end
  end
end
