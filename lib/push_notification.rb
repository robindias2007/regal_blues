module PushNotification
	def send_notification(token, alert, data)
		require 'houston'
		apn = Houston::Client.development
		path = Rails.root.join("public","Development_APNS_Certificate.pem")
    # apn.certificate = File.read("/home/yuva/Desktop/Development_APNS_Certificate.pem")
    apn.certificate = File.read(path)
    # token = "646CF0A42162B121ACD5653AC43B7A9D6EA9288F0C77B403EA2BC6FCFF28B4FB"
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