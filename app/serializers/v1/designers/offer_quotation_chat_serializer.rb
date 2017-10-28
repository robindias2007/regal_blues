# frozen_string_literal: true

class V1::Designers::OfferQuotationChatSerializer < ActiveModel::Serializer
  attributes :id, :chats

  def chats
    object.conversations.map do |convo|
      ActiveModelSerializers::SerializableResource.new(convo,
        serializer: V1::Users::ConversationSerializer).as_json
    end
  end
end
