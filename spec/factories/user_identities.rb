# frozen_string_literal: true

FactoryGirl.define do
  factory :user_identity do
    uid { Faker::Number.number(10) }
    provider { %w[Facebook Google].sample }
    user
  end
end
