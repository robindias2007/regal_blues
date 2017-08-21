# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    name { Faker::Commerce.unique.department(1) }
    image 'Some random string'
    super_category
  end
end
