# frozen_string_literal: true

class V1::Designers::OrderGiveMoreOptionsSerializer < ActiveModel::Serializer
  attributes :id, :price, :designer_note, :offer_quotation_galleries, :designer_additional_note

  def price
    offer_quotation&.price
  end

  def designer_note
    offer_quotation.description
  end

  def offer_quotation_galleries
    offer_quotation.offer_quotation_galleries.joins(:order_option)
                   .where(order_options: {
                     order: object, more_options: true, image_id: nil, designer_pick: false
                                         }).order(created_at: :asc).map do |oq|
      ActiveModelSerializers::SerializableResource.new(oq,
        serializer: V1::Designers::OfferQuotationGallerySerializer).as_json
    end
  end

  def designer_additional_note
    offer_quotation&.designer_note
  end

  def offer_quotation
    @offer_quotation ||= object.offer_quotation
  end
end
