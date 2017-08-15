# frozen_string_literal: true

class SubCategory < ApplicationRecord
  belongs_to :category

  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
