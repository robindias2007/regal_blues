# frozen_string_literal: true

module V1
  module Users
    class OrdersSerializer < ActiveModel::Serializer
      attributes :id, :designer_name, :item_type, :project, :price, :timeline

      def designer_name
        object.designer.designer_store_info.display_name
      end

      def item_type
        object.request.sub_category.name
      end

      def project
        object.request.name
      end

      def timeline
        object.request.timeline
      end
    end
  end
end
