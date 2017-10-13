# frozen_string_literal: true

class V1::Designers::OfferQuotationsSerializer < ActiveModel::Serializer
  attributes :id, :price, :description, :measurements, :galleries

  def measurements
    object.offer_measurements.map do |om|
      ActiveModelSerializers::SerializableResource.new(om,
        serializer: V1::Designers::OfferMeasurementSerializer).as_json
    end
  end

  def galleries
    object.offer_quotation_galleries.map do |oqg|
      ActiveModelSerializers::SerializableResource.new(oqg,
        serializer: V1::Designers::OfferQuotationGallerySerializer).as_json
    end
  end
end
