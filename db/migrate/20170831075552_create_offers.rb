class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers, id: :uuid do |t|
      t.references :designer, type: :uuid, index: true, foreign_key: true
      t.references :request, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
