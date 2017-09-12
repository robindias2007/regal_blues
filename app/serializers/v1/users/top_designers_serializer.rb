# frozen_string_literal: true

module V1
  module Users
    class TopDesignersSerializer < ActiveModel::Serializer
      attributes :id, :name, :min_price, :categories, :cover

      def name
        object.designer_store_info&.display_name || 'Default Store Name'
      end

      def min_price
        object.designer_store_info&.min_order_price&.round || 0.0
      end

      def categories
        cats = []
        object.sub_categories.each do |cat|
          cats << { name: cat.name, image: cat.image, id: cat.id }
        end
        cats
      end

      def cover
        # object.designer.designer_store_info
        'Some Image URL'
      end
    end
  end
end
