# frozen_string_literal: true

class Support < ApplicationRecord
  validate :full_name, :mobile_number, presence: true
  validates :email, format:     { with: /\A[A-Z0-9._%a-z\-]+@+amidostech\.com\z/, message: 'not valid email address' },
                    uniqueness: { case_sensitive: false }

  has_many :support_chats, dependent: :destroy
  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable
end
