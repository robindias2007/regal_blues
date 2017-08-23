# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    full_name Faker::Name.name
    username { Faker::Internet.user_name(Faker::Internet.user_name(4..40), '_') }
    mobile_number { '+' + [1, 49, 91].sample.to_s + Faker::Number.number(10) }
    gender Faker::Demographic.sex.downcase
    email { Faker::Internet.email }
    password Faker::Internet.password(10, 20)
  end
end
