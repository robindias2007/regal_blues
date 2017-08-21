# frozen_string_literal: true

class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :designer_categorizations
  has_many :requests

  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
