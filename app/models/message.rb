class Message < ApplicationRecord
	include PushNotification
	belongs_to :conversation
	mount_base64_uploader :attachment, ImageUploader

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
	  			NotificationsMailer.message_notification_support(sup, self, sender, type, type_name, offer_designer_name).deliver_later
	  			begin
	  				Message.new.msg_notification(sup.devise_token, self)
	  			rescue
	  			end
	  		end
	  	elsif sender.class.name == "Support"
	  		NotificationsMailer.message_notification(self.conversation.conversationable, self, sender).deliver_later
	  		begin
	  			Message.new.msg_notification(self.conversation.conversationable.devise_token, self)
  			rescue
  			end
	  	end
  	end
  end

  def type
    typ = self.conversation.receiver_type rescue ""
  end

  def offer_designer_name
    typ = type
    id = self.conversation.receiver_id
    if typ == "offers"
      designer_name = OfferQuotation.find(id).offer.designer.full_name rescue " "
    else
      designer_name = " "
    end
    return designer_name
  end

  def type_name
    typ = type
    id = self.conversation.receiver_id
    if typ == "support_general" || typ == "support"
      name = Support.find(id).full_name rescue " "
    elsif typ == "requests"
      name = Request.find(id).name
    elsif typ == "orders"
      name = Order.find(id).order_id rescue " "
    elsif typ == "offers"
      name = OfferQuotation.find(id).offer.request.name rescue " "
    else
      name = ""
    end
    return name
  end
end




