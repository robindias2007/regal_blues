# frozen_string_literal: true

class IndexService
  def initialize(category, price_low, price_high)
    @category = category
    @price_low = price_low
    @price_high = price_high
  end

  def products
    return all_products if no_params?
    return category_products if only_category?
    return price_filtered_products if only_filter_price?
    return category_and_price_filtered_products if both_category_and_filters?
  end

  private

  def all_products
    included_products.all
  end

  def category_products
    included_products.of_category(@category)
  end

  def price_filtered_products
    included_products.between_prices(@price_low, @price_high)
  end

  def category_and_price_filtered_products
    included_products.of_category(@category).between_prices(@price_low, @price_high)
  end

  def no_params?
    @category.nil? && @price_low.nil? && @price_high.nil?
  end

  def only_category?
    @category.present? && @price_low.nil? && @price_high.nil?
  end

  def only_filter_price?
    @category.nil? && @price_low.present? && @price_high.present?
  end

  def both_category_and_filters?
    @category.present? && @price_low.present? && @price_high.present?
  end

  def included_products
    Product.includes(designer: :designer_store_info)
  end
end
