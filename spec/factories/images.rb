# frozen_string_literal: true

FactoryGirl.define do
  factory :image do
    image 'MyString'
    height Faker::Number.number(3)
    width Faker::Number.number(3)
  end
end
