FactoryGirl.define do
  factory :conversation do
    support_chat "value"
    message "MyText"
    attachment "MyText"
  end
end
