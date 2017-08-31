# frozen_string_literal: true

FactoryGirl.define do
  factory :offer_measurement do
    data { { shoulder: '', waist: '' } }
    offer
  end
end
