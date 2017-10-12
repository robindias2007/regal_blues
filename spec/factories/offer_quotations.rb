# frozen_string_literal: true

FactoryGirl.define do
  factory :offer_quotation do
    price { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
    offer
  end
end
