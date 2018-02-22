# frozen_string_literal: true

class V1::Supports::UsersSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :username,  :conversation_id, :message_count

  def conversation_id
  	if object.conversations.present?
  		object.conversations.first.id
  	else
  		""
  	end
  end

  def message_count
  	if object.conversations.present?
  		object.conversations.first.messages.count
  	else
  		0
  	end
  end
end

