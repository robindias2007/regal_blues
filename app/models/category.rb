# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :super_category
  has_many :sub_categories

  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  mount_base64_uploader :image, ImageUploader
end
