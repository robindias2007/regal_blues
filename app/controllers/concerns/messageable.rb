module Messageable
  extend ActiveSupport::Concern
  # include PagerApi
  def index
		conversation = Conversation.find(params[:id])
		if conversation.present?
			# binding.pry
			messages = conversation.messages
			# binding.pry
			# messages = paginate messages.unscoped, per_page: 5
			# messages = conversation.messages if conversation.present?
			if messages.present?
				paginate json: messages, per_page: 10
				# render json: {messages: messages}, status: 201
				# messages
			else
				render json: {messages: "No message avilable"}, status: 400
			end
		end
	end

	def create
		conversation = Conversation.find(params[:id])
		message = conversation.messages.new(message_params)
		message.sender_id = current_resource.id
		if message.save!
			# render json: {message: Message.as_a_json(message)}, status: 201
			render json: {message: message}, status: 201
		else
			render json: {message: message.errors}, status: 400
		end
	end

	def update
		message = Message.find(params[:id])
		if message.update(read: params[:read])
			render json: {message: message}, status: 201
		else
			render json: {message: message.errors}, status: 400
		end
	end

	def notifications
		notifications = current_resource.notifications
		if notifications.present?
			render json: {notifications: notifications}, status: 201
		else
			render json: {notifications: "No Notification found"}
		end
	end

	private
	def message_params
    params.require(:message).permit(:body, :attachment)
  end
end