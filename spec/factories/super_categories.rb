# frozen_string_literal: true

FactoryGirl.define do
  factory :super_category do
    name { Faker::Commerce.department }
    image 'Some random string'
  end
end
