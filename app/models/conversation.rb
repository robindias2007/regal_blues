# frozen_string_literal: true

class Conversation < ApplicationRecord
	has_many :messages, dependent: :destroy
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  #belongs_to :sender, polymorphic: true, autosave: true, dependent: :destroy # Sender
  #belongs_to :receiver, polymorphic: true, autosave: true, dependent: :destroy # Receiver

  # validate :either_message_or_attachment
  validates :sender_id, :receiver_id, :receiver_type, presence: true
  
  validates_uniqueness_of :sender_id, :scope => :receiver_id

  scope :involving, -> (user) do
    where("conversations.sender_id =? OR conversations.receiver_id =?",user.id,user.id)
  end
  mount_base64_uploader :attachment, ImageUploader

  private

  # def either_message_or_attachment
  #   errors.add(:message, 'both fields cannot be present') if message.present? && attachment.present?
  # end
end
