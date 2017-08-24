# frozen_string_literal: true

class Request < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :sub_category
  has_many :images, as: :imageable
  has_many :request_designers

  validates :name, :size, :min_budget, :max_budget, :timeline, presence: true
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }
  validates :min_budget, numericality: true
  validates :max_budget, numericality: { greater_than: :min_budget }

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :request_designers

  enumerize :size, in: %w[xs-s s-m m-l l-xl xl-xxl], scope: true, predicates: true
end
