class EventsController < ApplicationController
	skip_before_action :verify_authenticity_token  

	def create
		debugger
		@event = Event.new(event_params)
		if @event.save!
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
		params.require(:event).permit(:resource_type, :username, :param1, :param2, :param3, :param4, :param5, :param6, :param7, :param8, :param9 , :param10)
	end	
end