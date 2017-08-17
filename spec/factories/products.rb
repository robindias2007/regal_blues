# frozen_string_literal: true

FactoryGirl.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description Faker::Lorem.paragraph
    selling_price Faker::Commerce.price
    active true
    designer_categorization
  end
end
