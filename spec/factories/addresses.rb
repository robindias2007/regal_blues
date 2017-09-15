# frozen_string_literal: true

FactoryGirl.define do
  factory :address do
    country { Faker::Address.country }
    pincode { Faker::Address.zip }
    street_address { Faker::Address.secondary_address + Faker::Address.street_address }
    landmark { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
    nickname { %w[home work other].sample }
    user
  end
end
