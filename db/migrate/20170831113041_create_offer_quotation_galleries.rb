class CreateOfferQuotationGalleries < ActiveRecord::Migration[5.1]
  def change
    create_table :offer_quotation_galleries, id: :uuid do |t|
      t.string :name, null: false, default: ''
      t.references :offer_quotation, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
