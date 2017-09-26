# frozen_string_literal: true

class Request < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :sub_category
  belongs_to :address
  has_many :request_images
  has_many :request_designers, dependent: :destroy
  has_many :offers, dependent: :destroy

  validates :name, :size, :max_budget, :timeline, presence: true
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }
  validates :min_budget, numericality: true, allow_nil: true
  validates :max_budget, numericality: { greater_than_or_equal_to: :min_budget }
  validates :address, presence: true, if: proc { |req| Address.ids_for(req.user_id) }

  accepts_nested_attributes_for :request_images
  accepts_nested_attributes_for :request_designers

  enumerize :size, in: %w[xs-s s-m m-l l-xl xl-xxl], scope: true, predicates: true

  def self.find_for(designer)
    joins(:request_designers).where(request_designers: { designer: designer, not_interested: false })
  end
end
