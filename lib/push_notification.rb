module PushNotification
	def send_notification(token, alert, data, extra_data={})
		require 'houston'
    # token = "811F650030353BE23A2072C7D892831BD7B0F43C994E8208781ABA848CA40F32"
		if token.present?
			apn = Houston::Client.production
			path = Rails.root.join("public","Production_APNS_Certificate.pem")
	    apn.certificate = File.read(path)
	    token = token
	    notification = Houston::Notification.new(device: token)
	    notification.alert = {title: "Custumise", body: alert}
	    notification.badge = 1
	    notification.sound = "default"
	    notification.category = "INVITE_CATEGORY"
	    # notification.content_available = true
	    notification.custom_data = {extraData: extra_data}
	    apn.push(notification)
	  end
	end

	def support_msg_notification(token, msg, alert)
		require 'houston'
		#token = "A39D1B9ADCFAA74D793268503DEC09A53BC6F232444D8ED4E1BED104F7AD942E"
		if token.present?
			apn = Houston::Client.production
			path = Rails.root.join("public","Production_Support_Certificate.pem")
			apn.certificate = File.read(path)
			token = token
	    notification = Houston::Notification.new(device: token)
	    notification.badge = 1
	    notification.sound = "default"
	    notification.alert = {title: title(msg), body: alert}
	    key = msg.conversation.receiver_type.singularize+"_id"
	    data = msg.conversation.receiver_id
	    conversation_id = msg.conversation.id
	    full_name = User.where(id:msg.conversation.conversationable_id).first.full_name
	    extraData = {"#{key}": data, message: msg.body, type: "chat", conversation_id:conversation_id, full_name:full_name }
	    notification.custom_data = {extraData: extraData}
	    apn.push(notification)
		end
	end

	def msg_notification(token, msg, alert)
		require 'houston'
		# token = "811F650030353BE23A2072C7D892831BD7B0F43C994E8208781ABA848CA40F32"
		if token.present?
			apn = Houston::Client.production
			path = Rails.root.join("public","Production_APNS_Certificate.pem")
			apn.certificate = File.read(path)
			token = token
	    notification = Houston::Notification.new(device: token)
	    notification.badge = 1
	    notification.sound = "default"
	    notification.alert = {title: title(msg), body: alert}
	    key = msg.conversation.receiver_type.singularize+"_id"
	    data = msg.conversation.receiver_id
	    extraData = {"#{key}": data, message: msg.body, type: "chat"}
	    notification.custom_data = {extraData: extraData}
	    apn.push(notification)
		end
	end

	def title(msg)
		conv = msg.conversation
		if conv.receiver_type == "requests"
			ttl = Request.find(conv.receiver_id).name rescue "Custumise"
		elsif conv.receiver_type == "orders"
			ttl = Order.find(conv.receiver_id).offer_quotation.offer.request.name rescue "Custumise"
		elsif conv.receiver_type == "offers"
			if conv.conversationable_type == "Designer"
				ttl = Offer.find(conv.receiver_id).request.name rescue "Custumise"
			elsif conv.conversationable_type == "User"
				ttl = OfferQuotation.find(conv.receiver_id).offer.request.name rescue "Custumise"
			end
		else
			ttl = "Custumise"
		end
		return ttl
	end
end