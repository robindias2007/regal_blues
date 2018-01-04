# frozen_string_literal: true

class V1::Users::OrderShowSerializer < ActiveModel::Serializer
  attributes :id, :request_id, :request_image, :designer_name, :designer_avatar, :category, :timeline, :paid_price,
    :project, :designer_note, :added_notes, :selections, :measurements, :status_log, :new_options, :order_id

  def request_id
    request&.id
  end

  def project
    request&.name
  end

  def request_image
    request.request_images.order(serial_number: :asc).first.image
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
    if object.order_options.present?
      object.order_options.where(more_options: false, designer_pick: false).order(created_at: :desc).map do |option|
        ActiveModelSerializers::SerializableResource.new(option,
          serializer: V1::Users::OrderOptionSerializer).as_json
      end
    end
  end

  def measurements
    if object.order_measurement.present?
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

  def new_options
    if object.more_options_for_user? || object.designer_selected_fabric_unavailable?
      object.offer_quotation.offer_quotation_galleries.joins(:images).where(images: { new: false }).first.map do |gallery|
        ActiveModelSerializers::SerializableResource.new(gallery,
          serializer: V1::Users::OfferQuotationGallerySerializer).as_json
      end
    end
  end

  private

  def request
    @request ||= offer_quotation.offer.request
  end

  def offer_quotation
    @oq ||= object.offer_quotation
  end
end
