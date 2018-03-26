# frozen_string_literal: true

class V1::Users::RequestsSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_type, :min_budget, :max_budget, :timeline, :offers_count, :status, :image, :offer_ids

  def item_type
    SubCategory.find(object.sub_category_id).name
  end

  def offers_count
    object.offers.count
  end

  def offer_ids
    object.offers.order(created_at: :asc).pluck(:id)
  end

  def image
    if object.request_images.present?
      object.request_images.order(serial_number: :asc).first.image
    else
      nil
    end
  end

end
