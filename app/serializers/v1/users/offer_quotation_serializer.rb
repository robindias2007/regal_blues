# frozen_string_literal: true

class V1::Users::OfferQuotationSerializer < ActiveModel::Serializer
  attributes :id, :price, :timeline, :description, :galleries, :order_present

  def timeline
    object.offer.request.timeline
  end

  def galleries
    object.offer_quotation_galleries.order(created_at: :desc).map do |oqg|
      ActiveModelSerializers::SerializableResource.new(oqg,
        serializer: V1::Users::OfferQuotationGallerySerializer).as_json
    end
  end

  def order_present
    Order.exists?(offer_quotation: object)
  end
end
