# frozen_string_literal: true

class SupportChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "support_chats_#{current_user.class.name.downcase}_#{current_user.id}"
    logger.add_tags 'SupportChatChannel', current_user.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def appear(chat_params)
    # binding.pry
  end

  # This receives the data even the method name tells something else.
  def send_convo(_chat_params)
    connect_to_support
      # support_chat = SupportChat.find_by(designer: current_user)
      # logger.add_tags support_chat
      # convo = support_chat.conversations.build(chat_params)
    
    if convo.save
      send_convo(convo)
    else
      broadcast_error_to_sender(convo)
    end
  end

  def connect_to_support
    resource = current_user.class.name.downcase
    support_chat = SupportChat.find_or_initialize_by(resource.to_s => current_user)
    if support_chat.present?
      broadcast_connection_new
      # logger.add_tags 'SupportChatChannel', 'support_chat already present'
    else
      support_chat.save
      broadcast_connection_existing
      # logger.add_tags 'SupportChatChannel', 'support_chat created'
    end
  end

  private

  def broadcast_convo_to_receiver(convo)
    ActionCable.server.broadcast("support_chats_#{convo.receiver_type.downcase}_#{convo.receiver_id}",
      message: convo.message, attachment: convo.attachment)
  end

  def broadcast_error_to_sender(convo)
    ActionCable.server.broadcast("support_chats_#{current_user.class.name.downcase}_#{current_user.id}",
      error: convo.errors)
  end

  def broadcast_connection_new
    ActionCable.server.broadcast("support_chats_#{current_user.class.name.downcase}_#{current_user.id}",
      message: 'Connection established with the support.')
  end

  def broadcast_connection_existing
    ActionCable.server.broadcast("support_chats_#{current_user.class.name.downcase}_#{current_user.id}",
      message: 'New connection has been established')
  end
end
