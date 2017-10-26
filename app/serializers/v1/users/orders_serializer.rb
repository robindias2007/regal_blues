# frozen_string_literal: true

class V1::Users::OrdersSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :item_type, :project, :price, :timeline, :created_at, :image, :status, :action

  def designer_name
    object.designer.designer_store_info.display_name
  end

  def item_type
    object.offer_quotation.request.sub_category.name
  end

  def project
    object.offer_quotation.request.name
  end

  def price
    object.offer_quotation.price
  end

  def timeline
    object.offer_quotation.request.timeline
  end

  def created_at
    object.order_status_log.send("#{status}_at")
  end

  def image
    object.order_options.where.not(image_id: nil).first.image.image ||
      object.offer_quotation.offer_quotation_galleries.first.images.first.image
  end

  def status
    object.status.to_s
  end
end
