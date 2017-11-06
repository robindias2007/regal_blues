# frozen_string_literal: true

class V1::Users::RequestsSerializer < ActiveModel::Serializer
  attributes :id, :name, :item_type, :min_budget, :max_budget, :timeline, :offers_count, :status, :image

  def item_type
    SubCategory.find(object.sub_category_id).name
  end

  def offers_count
    object.offers.count
  end

  def image
    object.request_images.order(serial_number: :asc).first.image
  end
end
