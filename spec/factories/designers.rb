# frozen_string_literal: true

FactoryGirl.define do
  factory :designer do
    full_name Faker::Name.name
    email { Faker::Internet.email }
    password Faker::Internet.password(10, 20)
    mobile_number { '+' + [1, 49, 91].sample.to_s + Faker::Number.number(10) }
    location Faker::LordOfTheRings.location
  end
end
