# frozen_string_literal: true

class V1::Designers::RequestChatQuotationSerializer < ActiveModel::Serializer
  attributes :id, :username, :price

  def username
    object.offer.request.user.username
  end
end
