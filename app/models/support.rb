# frozen_string_literal: true

class Support < ApplicationRecord
  include Authenticable

  has_many :support_chats, dependent: :destroy
  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'

  has_many :conversations, as: :personable, dependent: :destroy
end
