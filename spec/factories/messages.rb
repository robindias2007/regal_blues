FactoryGirl.define do
  factory :message do
    body "MyText"
    attachment "MyString"
    conversation_id 1
  end
end
