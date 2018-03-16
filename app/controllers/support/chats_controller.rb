class Support::ChatsController < ApplicationController
  
  def index
    convo_id = Message.pluck(:conversation_id).uniq
    user_id = Conversation.where(id:convo_id).pluck(:conversationable_id)
    @users = User.where(id:user_id).order(updated_at: :desc).paginate(:page => params[:page], :per_page => 100)
  end

end
