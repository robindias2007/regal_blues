# frozen_string_literal: true

FactoryGirl.define do
  factory :image do
    image 'MyString'
    height Faker::Number.number(3)
    width Faker::Number.number(3)
    trait :product do
      association :imageable, factory: :product_image
    end
  end
end
