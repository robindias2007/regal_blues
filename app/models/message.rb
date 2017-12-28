class Message < ApplicationRecord
	belongs_to :conversation
	mount_base64_uploader :attachment, ImageUploader

	def self.as_json messages
    messages.collect{|msg| {
      id: msg.id,
			body: msg.body,
			attachment: msg.attachment,
			conversation_id: msg.conversation_id,
			created_at: msg.created_at,
			updated_at: msg.updated_at,
			sender_id: msg.conversation.conversationable_id,
			receiver_id: msg.conversation.receiver_id
    }}
  end

  def self.as_a_json msg
  	{
  		id: msg.id,
			body: msg.body,
			attachment: msg.attachment,
			conversation_id: msg.conversation_id,
			created_at: msg.created_at,
			updated_at: msg.updated_at,
			sender_id: msg.conversation.conversationable_id,
			receiver_id: msg.conversation.receiver_id
  	}  	
  end
end
