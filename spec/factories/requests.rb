# frozen_string_literal: true

FactoryGirl.define do
  factory :request do
    min = Faker::Commerce.price
    name { Faker::Commerce.unique.product_name }
    size %w[xs-s s-m m-l l-xl xl-xxl].sample
    min_budget min
    max_budget 1.8 * min
    timeline Faker::Number.between(1, 10)
    description Faker::Lorem.paragraph
    user
    sub_category
  end
end
