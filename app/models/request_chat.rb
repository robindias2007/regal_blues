# frozen_string_literal: true

class RequestChat < ApplicationRecord
  belongs_to :request
  belongs_to :user
  belongs_to :designer, optional: true

  has_many :conversations, as: :chattable, dependent: :destroy
end
