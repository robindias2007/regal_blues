
#### RUN THIS SCHEDULER EVERYDAY BETWEEN 12 - 12:15 ########

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# Budget Low response - (To be sent after 2 days of request received)

scheduler.cron '0 0 0 * * 1-7 Asia/Kolkata' do 
	requests = Request.includes(:offers).where( :offers => { :request_id => nil } )
	if requests.present?
		requests.each do |f|
			if (f.created_at + 48.hours).to_date == Date.today
				unless f.user.conversations.present?
					convo = Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:f.user.id, conversationable_type:"User")		
				end
				body = "Hi #{f.user.full_name}! As per the designers, the budget is too low for the garment. Request you to kindly increase the same or select another outfit. Please make sure to enter your maximum budget, if your budget is low for the outfit requested and no options are possible then you will not get any offers from designers. Also note that designers will send you fabric options and work based on your budget and what best can be done close to your budget. Thank You!"
	  		message = Message.create(body:body, conversation_id:f.user.conversations.first.id, sender_id:Support.first.common_id)
	  		f.user.update(updated_at:DateTime.now)
			end
		end
	end
end


# Payment received and measurements pending - (To be sent after 1 day of payment made)

scheduler.cron '2 0 0 * * 1-7 Asia/Kolkata' do
	orders = Order.where(status:"designer_confirmed")
	if orders.present?
		orders.each do |f|
			if (f.created_at + 1.day).to_date == Date.today
				unless f.user.conversations.present?
					Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:f.user.id, conversationable_type:"User")		
				end
				body = "Thank You #{f.user.full_name}! We have received your payment. Kindly log in to your app and navigate to “Manage orders” in the “Accounts” to submit your managements."
	  		message = Message.create(body:body, conversation_id:f.user.conversations.first.id, sender_id:Support.first.common_id)
	  		f.user.update(updated_at:DateTime.now)
			end
		end
	end
end

# Offer sent but no response - (To be sent after 1 day of offer sent)

scheduler.cron '4 0 0 * * 1-7 Asia/Kolkata' do
	requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
	if requests.present?
		requests.each do |f|
			if (f.offers.first.created_at + 1.day).to_date == Date.today
				unless f.status == "confirmed"
					unless f.user.conversations.present?
						Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:f.user.id, conversationable_type:"User")		
					end
					body = "Hi #{f.user.full_name}! You have received a new offer for your request. Kindly login to our app, “ Account -> Manage Request” to respond to the offer. Do let us know incase you have questions regarding the same. Thank You!"
		  		message = Message.create(body:body, conversation_id:f.user.conversations.first.id, sender_id:Support.first.common_id)
		  		f.user.update(updated_at:DateTime.now)
		  	end	
			end
		end
	end
end

#Offer sent but no response - Reminder - (To be sent after 3 days of offer sent)

scheduler.cron '6 0 0 * * 1-7 Asia/Kolkata' do
	requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
	if requests.present?
		requests.each do |f|
			if (f.offers.first.created_at + 3.days).to_date == Date.today
				unless f.status == "confirmed"
					unless f.user.conversations.present?
						Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:f.user.id, conversationable_type:"User")		
					end
					body = "Hi #{f.user.full_name}! You have received a new offer for your request. Kindly login to our app, “ Account -> Manage Request” to respond to the offer. Do let us know incase you have questions regarding the same. Thank You!"
		  		message = Message.create(body:body, conversation_id:f.user.conversations.first.id, sender_id:Support.first.common_id)
		  		f.user.update(updated_at:DateTime.now)
		  	end	
			end
		end
	end
end

#Offer sent but no response - Reminder - (To be sent after 5 days of offer sent)

scheduler.cron '8 0 0 * * 1-7 Asia/Kolkata' do
	requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
	if requests.present?
		requests.each do |f|
			if (f.offers.first.created_at + 5.days).to_date == Date.today
				unless f.status == "confirmed"
					unless f.user.conversations.present?
						Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:f.user.id, conversationable_type:"User")		
					end
					body = "Hi #{f.user.full_name}! You have received a new offer for your request. Kindly login to our app, “ Account -> Manage Request” to respond to the offer. Do let us know incase you have questions regarding the same. Thank You!"
		  		message = Message.create(body:body, conversation_id:f.user.conversations.first.id, sender_id:Support.first.common_id)
		  		f.user.update(updated_at:DateTime.now)
		  	end	
			end
		end
	end
end
