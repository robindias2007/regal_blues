class Support::ChatsController < ApplicationController
  
  def chat_details
  	@chats = SupportChat.all 
  end

end