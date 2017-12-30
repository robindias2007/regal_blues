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

	def fabric_unavailable(order)
		@order = order
		mail to: order.user.email, subject: 'Fabric Unavailable'
	end

	def order_accept(order)
		@order = order
		mail to: order.designer.email, subject: 'Awaiting Confirmation'
	end

	def more_option(order)
		@order = order
		mail to: order.designer.email, subject: 'Awaiting Options'
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
		mail to: order.user.email, subject: 'Product Shipped to User'
	end

	def designer_shipped(order)
		@order = order
		mail to: order.designer.email, subject: 'Product Shipped to User'
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
end