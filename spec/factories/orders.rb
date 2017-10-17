# frozen_string_literal: true

FactoryGirl.define do
  factory :order do
    designer
    user
    offer_quotation
    status :started
  end
end
