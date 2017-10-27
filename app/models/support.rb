# frozen_string_literal: true

class Support < ApplicationRecord
  include Authenticable

  has_many :support_chats, dependent: :destroy

  has_many :conversations, as: :personable, dependent: :destroy
end
