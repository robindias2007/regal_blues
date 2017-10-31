# frozen_string_literal: true

class V1::Users::OfferQuotationChatSerializer < ActiveModel::Serializer
  attributes :id, :chats

  def chats
    object.conversations.order(created_at: :desc).map do |convo|
      ActiveModelSerializers::SerializableResource.new(convo,
        serializer: V1::Users::ConversationSerializer).as_json
    end
  end
end
