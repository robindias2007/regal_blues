# frozen_string_literal: true

FactoryGirl.define do
  factory :product_image do
    product
  end

  factory :image_of_product do
    profile { create :product_image }
    profile_type 'ProductImage'
  end
end
