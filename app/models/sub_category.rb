# frozen_string_literal: true

class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :designer_categorizations, dependent: :destroy
  has_many :designers, through: :designer_categorizations, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, :image, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  mount_base64_uploader :image, ImageUploader
end
