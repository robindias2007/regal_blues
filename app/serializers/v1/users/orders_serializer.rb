# frozen_string_literal: true

class V1::Users::OrdersSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :item_type, :project, :price, :timeline, :status_logged_at, :image, :status

  def designer_name
    object.designer.designer_store_info.display_name
  end

  def item_type
    request.sub_category.name
  end

  def project
    request.name
  end

  def price
    object.offer_quotation.price
  end

  def timeline
    request&.timeline
  end

  def status_logged_at
    object.order_status_log&.send("#{status}_at")&.strftime('%d %b %Y')
  end

  def image
    object.order_options.where.not(image_id: nil).first&.image&.image ||
      object.offer_quotation.offer_quotation_galleries&.first&.images&.first&.image
  end

  def status
    object.status.to_s
  end

  private

  def request
    @request ||= object.offer_quotation.offer.request
  end
end
