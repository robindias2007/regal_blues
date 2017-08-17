# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :designer_categorization

  validates :name, :description, :selling_price, :active, presence: true
  validates :name, length:     { in: 4..100 },
                   uniqueness: { case_insensitive: false,
                                 scope:            :designer_categorization_id }
  validates :description, length: { in: 50..300 }
  validates :selling_price, numericality: true

  before_save :generate_sku

  private

  def generate_sku
    return if sku.present?
    self.sku = generate_sku_token
  end

  def generate_sku_token
    loop do
      token = SecureRandom.base58(6).tr('liO0', 'sxyz').upcase
      break token unless Product.find_by(sku: token)
    end
  end
end
