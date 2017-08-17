# frozen_string_literal: true

FactoryGirl.define do
  factory :product_info do
    color Faker::Color.color_name
    fabric Faker::Lorem.words.join(', ')
    care Faker::Lorem.words(5).join(', ')
    notes Faker::Lorem.words(10).join(', ')
    work Faker::Lorem.words.join(', ')
    product
  end
end
