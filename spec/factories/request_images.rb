# frozen_string_literal: true

FactoryGirl.define do
  factory :request_image do
    image 'MyString'
    description 'MyText'
    color ''
    height 1
    width 1
    serial_number 1
    request
  end
end
