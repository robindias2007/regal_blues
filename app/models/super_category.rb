# frozen_string_literal: true

class SuperCategory < ApplicationRecord
  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
