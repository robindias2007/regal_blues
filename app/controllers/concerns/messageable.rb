module Messageable
  extend ActiveSupport::Concern

  def index
		conversation = Conversation.find(params[:id])
		messages = conversation.messages if conversation.present?
		if messages.present?
			render json: {messages: Message.as_json(messages)}, status: 201
		else
			render json: {messages: "No message avilable"}, status: 400
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

	private
	def message_params
    params.require(:message).permit(:body, :attachment)
  end
end