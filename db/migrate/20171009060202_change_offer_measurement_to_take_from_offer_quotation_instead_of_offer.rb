class ChangeOfferMeasurementToTakeFromOfferQuotationInsteadOfOffer < ActiveRecord::Migration[5.1]
  def change
    rename_column :offer_measurements, :offer_id, :offer_quotation_id
  end
end
