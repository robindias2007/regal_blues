class NotificationsMailer < ApplicationMailer

	def send_email(user)
		mail to: user.email, subject: 'Welcome to Custumise'
	end

	def send_confirmed_email(resource)
		@resource = resource
		mail to: resource.email, subject: 'Email Verified'
	end

	def password_change(resource)
		mail to: resource.email, subject: 'Password Changed'
	end

	def new_request(user, designer)
		@user = user
		mail to: designer.email, subject: 'New Request'
	end

	def new_offer(offer)
		@request = offer.request
		@designer = offer.designer 
		mail to: offer.request.user.email, subject: 'New Offer'		
	end

	def payment(user, order_payment)
		@order = order_payment.order
		@designer = order_payment.order.designer
		mail to: user.email, subject: 'Payment Successful'
	end

	def order_confirm(order)
		@order = order
		mail to: order.user.email, subject: 'Order Confirmed'
	end

	def order_cancel(resource, order)
		@order = order
		@resource = resource
		mail to: resource.email, subject: 'Order Cancelled'
	end
end