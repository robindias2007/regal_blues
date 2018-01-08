FactoryGirl.define do
  factory :notification do
    body "MyText"
    resourceable_id "MyText"
    resourceable_type "MyString"
    type ""
  end
end
