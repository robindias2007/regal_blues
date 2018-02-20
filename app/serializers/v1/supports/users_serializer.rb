# frozen_string_literal: true

class V1::Supports::UsersSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :username,  :conversation_id, :support_id

  def conversation_id
  	if object.conversations.present?
  		object.conversations.first.id
  	else
  		""
  	end
  end

  def support_id
  	Support.first.common_id
  end


end

