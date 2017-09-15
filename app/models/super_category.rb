# frozen_string_literal: true

class SuperCategory < ApplicationRecord
  has_many :categories

  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  mount_base64_uploader :image, ImageUploader
end
