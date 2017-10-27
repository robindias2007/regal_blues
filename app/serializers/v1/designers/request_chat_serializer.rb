# frozen_string_literal: true

class V1::Designers::RequestChatSerializer < ActiveModel::Serializer
  attributes :id, :chats, :offer_quotations_count, :offers_present

  def chats
    object.conversations.map do |convo|
      ActiveModelSerializers::SerializableResource.new(convo,
        serializer: V1::Users::ConversationSerializer).as_json
    end
  end

  def offers_present
    offers.count.positive?
  end

  def offer_quotations_count
    ids = offers.pluck(:id)
    OfferQuotation.where(offer_id: ids).count
  end

  def offers
    @offers ||= object.request.offers.where(designer_id: @instance_options[:designer_id])
  end
end
