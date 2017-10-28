class CreateOfferQuotationChats < ActiveRecord::Migration[5.1]
  def change
    create_table :offer_quotation_chats, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.references :designer, type: :uuid, index: true, foreign_key: true
      t.references :offer_quotation, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
