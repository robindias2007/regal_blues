# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :user
  belongs_to :sub_category
  has_many :images, as: :imageable
  has_many :request_designers

  validates :name, :size, :min_budget, :max_budget, :timeline, presence: true
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }

  accepts_nested_attributes_for :images
end
