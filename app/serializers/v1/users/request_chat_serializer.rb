# frozen_string_literal: true

class V1::Users::RequestChatSerializer < ActiveModel::Serializer
  attributes :id, :chats, :offer_count

  def chats
    object.conversations.map do |convo|
      ActiveModelSerializers::SerializableResource.new(convo,
        serializer: V1::Users::ConversationSerializer).as_json
    end
  end

  def offer_count
    object.request.offers.count
  end
end
