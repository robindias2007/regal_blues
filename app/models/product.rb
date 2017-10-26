# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :sub_category
  belongs_to :designer
  has_one :product_info, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy

  validates :name, :description, :selling_price, presence: true
  validates :name, length:     { in: 4..100 },
                   uniqueness: { case_insensitive: false,
                                 scope:            :designer_id }
  validates :description, length: { in: 50..300 }
  validates :selling_price, numericality: { greater_than_or_equal_to: proc { |product|
                                                                        product&.designer&.designer_store_info
                                                                               &.min_order_price || 5_000
                                                                      } }
  validates :sub_category, presence: true, if: proc { |product|
                                                 DesignerCategorization.cat_ids_of_designer(product.designer_id)
                                               }

  before_save :generate_sku

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :product_info

  def self.of_category(category_id)
    where(sub_category_id: category_id)
  end

  def self.between_prices(low, high)
    where('selling_price >= ? AND selling_price <= ?', low, high)
  end

  def self.search_for(query)
    where('similarity(name, ?) > 0.15', query)
      .order("similarity(name, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def self.of_designer(designer_id)
    where(designer_id: designer_id)
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update!(:"#{attr}" => false) : update!(:"#{attr}" => true)
  end

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
