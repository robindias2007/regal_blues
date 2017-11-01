# frozen_string_literal: true

class V1::Users::OrderOptionSerializer < ActiveModel::Serializer
  attributes :id, :gallery_name, :image, :more_options, :designer_pick

  def gallery_name
    object.offer_quotation_gallery.name
  end

  def image
    if object.image.present?
      ActiveModelSerializers::SerializableResource.new(object&.image,
        serializer: ImageSerializer).as_json
    end
  end

  def more_options
    object&.more_options
  end

  def designer_pick
    object&.designer_pick
  end
end
