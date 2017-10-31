# frozen_string_literal: true

class V1::Users::OffersSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :item_type, :prices, :sent_on, :image

  def designer_name
    object.designer.designer_store_info.display_name
  end

  def item_type
    object.request.sub_category.name
  end

  def prices
    object.offer_quotations.order(created_at: :desc).pluck(:price)
  end

  def sent_on
    object.created_at.strftime('%d %b %Y')
  end

  def image
    object.designer.avatar
  end
end
