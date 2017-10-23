class AddFabricUnavailableNoteToOfferQuotation < ActiveRecord::Migration[5.1]
  def change
    add_column :offer_quotations, :fabric_unavailable_note, :text
  end
end
