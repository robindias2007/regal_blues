# frozen_string_literal: true

class V1::Users::SearchDesignersSerializer < ActiveModel::Serializer
  attributes :id, :name, :cover

  def id
    object.designer.id
  end

  def name
    object.display_name
  end

  def cover
    object.designer.avatar&.url || 'Some Image URL'
  end
end
