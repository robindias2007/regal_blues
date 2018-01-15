module Messageable
  extend ActiveSupport::Concern
  def index
		conversation = Conversation.find(params[:id])
		if conversation.present?
			messages = conversation.messages.order(created_at: :asc).paginate(page: params[:page], per_page: 10)
			if messages.present?
				render :json => {
		      :current_page => messages.current_page,
		      :per_page => messages.per_page,
		      :total_entries => messages.total_entries,
		      :messages => messages
		    }
			else
				render json: {messages: "No message avilable"}, status: 400
			end
		end
	end

	def create
		conversation = Conversation.find(params[:id])
		message = conversation.messages.new(message_params)
		message.sender_id = current_resource.id
		if message.save
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