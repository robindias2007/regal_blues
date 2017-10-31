# frozen_string_literal: true

module V1
  module Users
    class DesignerShowSerializer < ActiveModel::Serializer
      attributes :id, :name, :min_price, :cover, :processing_time, :location, :sales,
        :member_since, :collection, :bio

      def name
        object.designer_store_info&.display_name || 'Default Store Name'
      end

      def min_price
        object.designer_store_info&.min_order_price&.round || 0.0
      end

      def processing_time
        "#{object.designer_store_info&.processing_time || 6} weeks"
      end

      def location
        "#{object.designer_store_info&.city}, #{object.designer_store_info&.country}"
      end

      def sales
        # TODO: Change this
        # object.orders.size
        '999'
      end

      def member_since
        object.created_at.strftime('%Y')
      end

      def bio
        # TODO: Change this
        # object.designer_store_info&.bio
        'Not implemented'
      end

      def collection
        products = object.products.order(created_at: :desc).limit(4)
        products.map do |product|
          ActiveModelSerializers::SerializableResource.new(product,
            serializer: V1::Users::ProductsSerializer).as_json
        end
      end

      def cover
        object.avatar
      end
    end
  end
end
