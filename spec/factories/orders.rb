# frozen_string_literal: true

FactoryGirl.define do
  factory :order do
    designer
    user
    offer_quotation
    cancelled false
    paid false
    measurements_given false

    trait :paid do
      paid true
    end

    trait :unpaid do
      paid false
    end

    trait :measurements_given do
      measurements_given true
    end

    trait :measurements_not_given do
      measurements_given false
    end

    trait :cancelled do
      cancelled true
    end
  end
end
