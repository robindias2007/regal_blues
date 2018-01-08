# frozen_string_literal: true

class Support < ApplicationRecord
  include Authenticable
  extend Enumerize
  # validates :full_name, :mobile_number, presence: true
  # validates :email, format:     { with: /\A[A-Z0-9._%a-z\-]+@+amidostech\.com\z/, message: 'not valid email address' },
  #                   uniqueness: { case_sensitive: false }
  # validates :mobile_number, uniqueness: true, allow_nil: true, length: { in: 10..14 }

  has_many :conversations, as: :conversationable
  has_many :support_chats, dependent: :destroy
  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'
  has_many :notifications, as: :resourceable

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  def self.as_json(current_resource)
    Support.all.collect{|support| { 
      id: support.id,
      message_count: support.msg_count(current_resource, support),
      unread_message_count: support.unread_msg_count(current_resource, support)
    }}
  end


  def msg_count(res, support)
    return res.conversations.where(receiver_id: support.id)[0].messages.count rescue 0
  end

  def unread_msg_count(res, support)
    return res.conversations.where(receiver_id: support.id)[0].messages.where(read: false).count rescue 0
  end
end
