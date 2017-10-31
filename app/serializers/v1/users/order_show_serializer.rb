# frozen_string_literal: true

class V1::Users::OrderShowSerializer < ActiveModel::Serializer
  attributes :id, :request_id, :request_image, :designer_name, :category, :timeline, :paid_price, :designer_note,
    :added_notes, :selections, :measurements, :status_log

  def request_id
    request&.id
  end

  def request_image
    request.request_images.order(created_at: :asc).first.image
  end

  def designer_name
    object.offer_quotation.offer.designer.designer_store_info.display_name
  end

  def designer_avatar
    object.offer_quotation.offer.designer.avatar
  end

  def category
    request.sub_category.name
  end

  def timeline
    request&.timeline
  end

  def paid_price
    offer_quotation&.price
  end

  def designer_note
    offer_quotation&.description
  end

  def added_notes
    offer_quotation&.designer_note
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

  def status_log
    {
      status: object.status,
      date:   object.order_status_log&.send("#{object.status}_at")&.strftime('%d %b %Y')
    }
  end

  private

  def request
    @request ||= offer_quotation.offer.request
  end

  def offer_quotation
    @oq ||= object.offer_quotation
  end
end
