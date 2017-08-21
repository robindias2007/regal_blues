# frozen_string_literal: true

FactoryGirl.define do
  factory :request_image do
    request
  end

  factory :image_of_request do
    profile { create :request_image }
    profile_type 'RequestImage'
  end
end
