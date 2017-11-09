FactoryGirl.define do
  factory :order_payment do
    order nil
    user nil
    price 1
    payment_id "MyString"
    success false
    extra ""
  end
end
