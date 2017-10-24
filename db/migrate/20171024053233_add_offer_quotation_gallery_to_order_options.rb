class AddOfferQuotationGalleryToOrderOptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_options, :offer_quotation_gallery, type: :uuid, index: true, foreign_key: true
  end
end
