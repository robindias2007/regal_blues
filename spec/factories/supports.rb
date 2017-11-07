# frozen_string_literal: true

FactoryGirl.define do
  factory :support do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
