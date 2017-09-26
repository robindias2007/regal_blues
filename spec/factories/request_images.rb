FactoryGirl.define do
  factory :request_image do
    image "MyString"
    description "MyText"
    color "MyString"
    height 1
    width 1
    request nil
  end
end
