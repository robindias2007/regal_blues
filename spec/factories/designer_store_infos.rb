# frozen_string_literal: true

FactoryGirl.define do
  factory :designer_store_info do
    display_name { Faker::Company.name }
    registered_name { Faker::Company.name + Faker::Company.suffix }
    pincode Faker::Number.number(6)
    country Faker::Address.country
    state Faker::Address.state
    city Faker::Address.city
    address_line_1 Faker::Address.street_address
    contact_number Faker::Number.number(10)
    min_order_price Faker::Commerce.price
    processing_time Faker::Number.number(2)
    designer
  end
end
