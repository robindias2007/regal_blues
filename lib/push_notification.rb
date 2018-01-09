module PushNotification
	def send_notification(token, alert, data)
		require 'houston'
		if token.present?
			apn = Houston::Client.development
			path = Rails.root.join("public","Development_APNS_Certificate.pem")
	    apn.certificate = File.read(path)
	    token = token
	    notification = Houston::Notification.new(device: token)
	    notification.alert = alert
	    notification.badge = 1
	    notification.sound = "sosumi.aiff"
	    notification.category = "INVITE_CATEGORY"
	    notification.content_available = true
	    notification.custom_data = {data: data}
	    apn.push(notification)
	  end
	end

	def msg_notification(token, msg)
		require 'houston'
		if token.present?
			binding.pry
			apn = Houston::Client.development
			path = Rails.root.join("public","Development_APNS_Certificate.pem")
			apn.certificate = File.read(path)
			token = token
	    notification = Houston::Notification.new(device: token)
	    notification.badge = 1
	    notification.sound = "default"
	    notification.alert = {title: msg.conversation.receiver_type, body: "You have new message"}
	    key = msg.conversation.receiver_type.singularize+"_id"
	    data = msg.conversation.receiver_id
	    extraData = {"#{key}": data, message: msg.body}
	    notification.custom_data = {extraData: extraData}
	    binding.pry
	    apn.push(notification)
		end
	end
end