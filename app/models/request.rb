# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :user
  belongs_to :sub_category

  validates :name, :size, :min_budget, :max_budget, :timeline, presence: true
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }
end
