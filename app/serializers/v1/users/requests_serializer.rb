# frozen_string_literal: true

class V1::Users::RequestsSerializer < ActiveModel::Serializer
  # attributes :id, :name, :item_type, :min_budget, :max_budget, :timeline, :offers_count
  attributes :id, :name, :item_type, :max_budget, :timeline, :offers_count, :status

  def item_type
    SubCategory.find(object.sub_category_id).name
  end

  def offers_count
    object.offers.count
  end
end
