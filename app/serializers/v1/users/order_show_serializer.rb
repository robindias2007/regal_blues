# frozen_string_literal: true

class V1::Users::OrderShowSerializer < ActiveModel::Serializer
  attributes :id, :request_id, :request_image, :designer_name, :category, :timeline, :paid_price, :designer_note,
    :added_notes, :selections, :measurements

  def request_id
    object.offer_quotation.offer.request.id
  end

  def request_image
    object.offer_quotation.offer.request.request_images.order(created_at: :asc).first.image
  end

  def designer_name
    object.offer_quotation.offer.designer.designer_store_info.display_name
  end

  def category
    object.offer_quotation.offer.request.sub_category.name
  end

  def timeline
    object.offer_quotation.offer.request.timeline
  end

  def paid_price
    object.offer_quotation.price
  end

  def designer_note
    object.offer_quotation.description
  end

  def added_notes
    object.offer_quotation.designer_note
  end

  def selections
    object.order_options.map do |option|
      ActiveModelSerializers::SerializableResource.new(option,
        serializer: V1::Users::OrderOptionSerializer).as_json
    end
  end

  def measurements
    if object.order_measurement
      ActiveModelSerializers::SerializableResource.new(object&.order_measurement,
        serializer: V1::Users::OrderMeasurementSerializer).as_json
    end
  end
end
