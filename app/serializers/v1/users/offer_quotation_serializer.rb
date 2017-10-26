# frozen_string_literal: true

class V1::Users::OfferQuotationSerializer < ActiveModel::Serializer
  attributes :id, :price, :timeline, :description, :galleries

  def timeline
    object.offer.request.timeline
  end

  def galleries
    object.offer_quotation_galleries.map do |oqg|
      ActiveModelSerializers::SerializableResource.new(oqg,
        serializer: V1::Users::OfferQuotationGallerySerializer).as_json
    end
  end
end
