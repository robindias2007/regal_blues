class CreateOfferQuotations < ActiveRecord::Migration[5.1]
  def change
    create_table :offer_quotations, id: :uuid do |t|
      t.decimal :price, null: false, default: 0.0, precision: 12, scale: 2
      t.text :description, null: false, default: ''
      t.references :offer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
