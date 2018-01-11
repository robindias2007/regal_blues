# frozen_string_literal: true

class V1::Users::OfferShowSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :item_type, :prices, :shipping_price, :sent_on, :store_avatar, :project, :max_budget,
    :quotations, :status

  def designer_name
    object.designer.designer_store_info.display_name
  end

  def item_type
    object.request.sub_category.name
  end

  def prices
    object.offer_quotations.pluck(:price)
  end

  def shipping_price
    if object.request.address == "India"
      500
    else
      1400
    end
  end

  def sent_on
    object.created_at.strftime('%d %b %Y')
  end

  def store_avatar
    object.designer.avatar
  end

  def project
    object.request.name
  end

  def max_budget
    object.request.max_budget
  end

  def status
    object.request.status
  end

  def quotations
    object.offer_quotations.order(created_at: :desc).map do |quote|
      ActiveModelSerializers::SerializableResource.new(quote,
        serializer: V1::Users::OfferQuotationSerializer).as_json
    end
  end
end
