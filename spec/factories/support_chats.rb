FactoryGirl.define do
  factory :support_chat do
    support nil
    user nil
    designer nil
    message "MyText"
    attachment "MyText"
    responding false
  end
end
