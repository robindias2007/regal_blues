# frozen_string_literal: true

module V1
  module Users
    class ProductsSerializer < ActiveModel::Serializer
      attributes :id, :name, :designer_name, :selling_price, :image

      def designer_name
        object&.designer&.designer_store_info&.display_name || 'Generic Store Name'
      end

      def image
        # TODO: Change this to the cover image of the store
        object.designer.avatar || 'Default Image URL'
      end
    end
  end
end
