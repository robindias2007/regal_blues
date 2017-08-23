# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :sub_category
  belongs_to :designer
  has_one :product_info
  has_many :images, as: :imageable

  validates :name, :description, :selling_price, :active, presence: true
  validates :name, length:     { in: 4..100 },
                   uniqueness: { case_insensitive: false,
                                 scope:            :designer_id }
  validates :description, length: { in: 50..300 }
  validates :selling_price, numericality: true
  validates :sub_category, presence: true, if: proc { |product|
                                                 DesignerCategorization.cat_ids_of_designer(product.designer_id)
                                               }

  before_save :generate_sku

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :product_info

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
