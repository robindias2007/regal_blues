# frozen_string_literal: true

class SupportChat < ApplicationRecord
  belongs_to :support, optional: true
  belongs_to :user, optional: true
  belongs_to :designer, optional: true

  has_many :conversations, as: :chattable, dependent: :destroy

  after_initialize :set_responding_false

  def set_responding_false
    self.responding = false if responding.nil?
  end
end
