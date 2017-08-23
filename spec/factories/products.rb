# frozen_string_literal: true

FactoryGirl.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description Faker::Lorem.paragraph
    selling_price Faker::Commerce.price
    sub_category
    designer

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end
  end
end
