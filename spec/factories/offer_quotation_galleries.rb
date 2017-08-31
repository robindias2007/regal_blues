# frozen_string_literal: true

FactoryGirl.define do
  factory :offer_quotation_gallery do
    name { Faker::HarryPotter.quote }
    offer_quotation
  end
end
