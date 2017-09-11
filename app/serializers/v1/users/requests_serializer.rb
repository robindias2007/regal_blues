# frozen_string_literal: true

module V1
  module Users
    class RequestsSerializer < ActiveModel::Serializer
      attributes :id, :name, :item_type, :min_budget, :max_budget, :timeline, :offers_present?, :offers_count

      def item_type
        SubCategory.find(object.sub_category_id).name
      end

      def offers_present?
        object.offers.present?
      end

      def offers_count
        object.offers.count
      end
    end
  end
end
