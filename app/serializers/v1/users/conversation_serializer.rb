# frozen_string_literal: true

class V1::Users::ConversationSerializer < ActiveModel::Serializer
  attributes :id, :message, :attachment, :created_at, :by

  def by
    if object.personable.class == Designer
      object.personable.designer_store_info.display_name
    elsif object.personable.class == User
      object.personable.username
    elsif object.personable.class == Support
      object.personable.full_name
    end
  end
end
