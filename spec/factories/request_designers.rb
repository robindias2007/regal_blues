# frozen_string_literal: true

FactoryGirl.define do
  factory :request_designer do
    not_interested false
    request
    designer
  end
end
