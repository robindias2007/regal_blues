# frozen_string_literal: true

class V1::Designers::ConversationSerializer < ActiveModel::Serializer
  attributes :id, :message, :attachment, :created_at
end
