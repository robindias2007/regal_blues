# frozen_string_literal: true

class V1::Users::RequestDesignerSerializer < ActiveModel::Serializer
  attributes :id, :gold, :display_name, :store_cover

  def gold
  	object.gold
  end

  def display_name
    object.designer_store_info&.display_name
  end

  def store_cover
    object.avatar
  end
end
