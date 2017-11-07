# frozen_string_literal: true

class Support < ApplicationRecord
  has_many :support_chats, dependent: :destroy
  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable
end
