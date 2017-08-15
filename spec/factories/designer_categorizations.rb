# frozen_string_literal: true

FactoryGirl.define do
  factory :designer_categorization do
    designer
    sub_category
  end
end
