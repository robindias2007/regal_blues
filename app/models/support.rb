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
    return {
      common_id: comman_support_id,
      message_count: msg_count(current_resource),
      unread_message_count: unread_msg_count(current_resource)
    }
  end


  def self.msg_count(res)
    return res.conversations.where(receiver_id: comman_support_id)[0].messages.count rescue 0
  end

  def self.unread_msg_count(res)
    return res.conversations.where(receiver_id: comman_support_id)[0].messages.where(read: false).count rescue 0
  end

  def self.comman_support_id
    return Support.last.common_id rescue ""
  end
end
