class RenameFabricUnavailableNoteToDesignerNoteForOfferQuotations < ActiveRecord::Migration[5.1]
  def change
    rename_column :offer_quotations, :fabric_unavailable_note, :designer_note
  end
end
