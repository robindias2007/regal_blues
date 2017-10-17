# frozen_string_literal: true

FactoryGirl.define do
  factory :order_option do
    order
    image
    more_options false
    designer_pick false
  end
end
