class NotificationsMailer < ApplicationMailer

	def send_email(user)
		@user = user
		@path = user.class.name.downcase.pluralize
    	@token = user.confirmation_token
		mail to: user.email, subject: 'Welcome to Custumise! We are glad to have you here'
	end

	def send_confirmed_email(resource)
		@resource = resource
		mail to: resource.email, subject: 'Account Verification successful'
	end

	def password_change(resource)
		@resource = resource
		mail to: resource.email, subject: 'Password successfully changed'
	end

	def new_request(user, designer)
		@user = user
		@designer = designer
		mail to: designer.email, subject: 'You have a new request'
	end

	def new_offer(offer)
		@request = offer.request
		@designer = offer.designer 
		mail to: @request.user.email, subject: 'You have a new offer'		
	end

	def payment(user, order_payment)
		@user = user
		@order = order_payment.order
		@designer = order_payment.order.designer
		mail to: user.email, subject: 'Payment Successful'
	end

	def order_confirm(order)
		@order = order
		mail to: order.user.email, subject: 'Your order is confirmed'
	end

	def order_cancel(resource, order)
		@order = order
		@resource = resource
		mail to: resource.email, subject: 'Order Cancelled'
	end

	def fabric_unavailable(order)
		@order = order
		mail to: order.user.email, subject: 'Fabric of your choice is unavailable'
	end

	def order_accept(order)
		@order = order
		mail to: order.designer.email, subject: 'Awaiting Designer Confirmation'
	end

	def more_option(order)
		@order = order
		mail to: order.designer.email, subject: 'Awaiting more options on your offer'
	end

	def new_option(order)
		@order = order
		mail to: order.user.email, subject: 'More Options'
	end

	def under_qc(order)
		@order = order
		mail to: order.user.email, subject: 'Product Under QC'
	end

	def shipped_to_user(order)
		@order = order
		mail to: order.user.email, subject: 'Your order has been shipped'
	end

	def designer_shipped(order)
		@order = order
		mail to: order.designer.email, subject: 'Your order has been shipped'
	end

	def rejected_in_qc(order)
		@order = order
		mail to: order.designer.email, subject: 'Rejected in QC'
	end

	def product_deliverd(order)
		@order = order
		mail to: order.user.email, subject: 'Product Delivered'
		mail to: order.designer.email, subject: 'Product Delivered'
	end

	def message_notification(resource, msg)
		@message = msg
		mail to: resource.email, subject: 'New Message'
	end

	def give_measurement(order)
		@order = order
		mail to: order.user.email, subject: 'Measurements Pending'
	end

	def interested(request_designer)
		@request_designer = request_designer
		mail to: request_designer.designer.email, subject: ' 48 hrs left to send quote for the request'
	end

	def penalty(request_designer)
		@request_designer = request_designer
		mail to: request_designer.designer.email, subject: 'Quote Penalty'
	end
end