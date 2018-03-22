class EventsController < ApplicationController
	skip_before_action :verify_authenticity_token  

	def create
		@event = Event.new(event_params)
		if @event.save!
			if @event.event_name == "CLOSE_REQUEST"
				user = User.find_by(username:@event.username)
				message_body = "Hi! We noticed that you tried placing a request on our app. In case you are having trouble submitting requests or have some questions, do let us know we are just a chat away! We can also create a request for you, please share the reference outfit image, any color preference, budget, size, phone number and any specific preferences/changes."
				if user.conversations.present?
		      message = Message.create(body:message_body, conversation_id:user.conversations.first.id, sender_id:Support.first.common_id)
		      user.update(updated_at:DateTime.now)  
		    else
		      convo = Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:user.id, conversationable_type:"User")   
		      message = Message.create(body:message_body, conversation_id:convo.id, sender_id:Support.first.common_id)
		      user.update(updated_at:DateTime.now)
		    end
			end
      render json: { message: 'Event Updated' }, status: 201
		else
      render json: { message: 'Event Couldnt Be Updated' }, status: 404
    end
	end

	def index
		@events = Event.all
		if @events.present?
      render json: @events
		else
      render json: { message: 'NOT DONE' }, status: 404
    end
	end

	private

	def event_params
		params.require(:event).permit(:resource_type, :username, :event_name, :param1, :param2, :param3, :param4, :param5, :param6, :param7, :param8, :param9 , :param10)
	end	
end