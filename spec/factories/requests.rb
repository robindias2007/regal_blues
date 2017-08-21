# frozen_string_literal: true

FactoryGirl.define do
  factory :request do
    min = Faker::Commerce.price
    name { Faker::Commerce.product_name }
    size %w[xs-s s-m m-l l-xl xl-xxl].sample
    min_budget min
    max_budget min + 10_000
    timeline Faker::Number.between(1, 10)
    description Faker::Lorem.paragraph
    user
    sub_category
  end
end
