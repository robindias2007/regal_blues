class Message < ApplicationRecord
	belongs_to :conversation
	mount_base64_uploader :attachment, ImageUploader

	validates_length_of :body, :minimum => 1

	after_create :notify

	def self.as_json messages
    messages.collect{|msg| {
      id: msg.id,
			body: msg.body,
			attachment: msg.attachment,
			conversation_id: msg.conversation_id,
			created_at: msg.created_at,
			updated_at: msg.updated_at,
			sender_id: msg.sender_id,
			read: msg.read,
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

  def notify
  	sender = Support.find(self.sender_id) rescue sender = User.find(self.sender_id) rescue sender = Designer.find(self.sender_id)
  	if sender.present?
  		if sender.class.name == "Designer" || sender.class.name == "User"
	  		Support.all.each do |sup|
	  			NotificationsMailer.message_notification(sup, self).deliver
	  		end
	  	elsif sender.class.name == "Support"
	  		NotificationsMailer.message_notification(self.conversation.conversationable, self).deliver
	  	end
  	end
  end
end
