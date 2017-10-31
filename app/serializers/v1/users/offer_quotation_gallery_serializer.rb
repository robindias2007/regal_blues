# frozen_string_literal: true

class V1::Users::OfferQuotationGallerySerializer < ActiveModel::Serializer
  attributes :id, :name, :images

  def images
    object.images.order(created_at: :desc).map do |image|
      ActiveModelSerializers::SerializableResource.new(image,
        serializer: ImageSerializer).as_json
    end
  end
end
