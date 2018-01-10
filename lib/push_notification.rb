module PushNotification
	def send_notification(token, alert, data)
		require 'houston'
		if token.present?
			apn = Houston::Client.production
			path = Rails.root.join("public","Production_APNS_Certificate.pem")
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
		# token = "50285224824E89B8BE2EE0A0388C6D959E348BAA599781AE29C976646E925274"
		if token.present?
			apn = Houston::Client.production
			path = Rails.root.join("public","Production_APNS_Certificate.pem")
			apn.certificate = File.read(path)
			token = token
	    notification = Houston::Notification.new(device: token)
	    notification.badge = 1
	    notification.sound = "default"
	    notification.alert = {title: "Custumise", body: "You have new message"}
	    key = msg.conversation.receiver_type.singularize+"_id"
	    data = msg.conversation.receiver_id
	    extraData = {"#{key}": data, message: msg.body}
	    notification.custom_data = {extraData: extraData}
	    apn.push(notification)
		end
	end
end