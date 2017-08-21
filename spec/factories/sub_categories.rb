# frozen_string_literal: true

FactoryGirl.define do
  factory :sub_category do
    name { Faker::Commerce.department(1) }
    image 'Some random string'
    category
  end
end
