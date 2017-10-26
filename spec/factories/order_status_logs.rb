FactoryGirl.define do
  factory :order_status_log do
    order nil
    started_at "2017-10-26 14:58:10"
    paid_at "2017-10-26 14:58:10"
    designer_confirmed_at "2017-10-26 14:58:10"
    measurements_given_at ""
    in_production_at "2017-10-26 14:58:10"
    shipped_to_qc_at "2017-10-26 14:58:10"
    delivered_to_qc_at "2017-10-26 14:58:10"
    in_qc_at "2017-10-26 14:58:10"
    shipped_to_user_at "2017-10-26 14:58:10"
    delivered_to_user_at "2017-10-26 14:58:10"
    rejected_by_qc_at "2017-10-26 14:58:10"
    user_awaiting_more_options_at "2017-10-26 14:58:10"
    designer_gave_more_options_at "2017-10-26 14:58:10"
    user_selected_options_at "2017-10-26 14:58:10"
    user_cancelled_at "2017-10-26 14:58:10"
    designer_selected_fabric_unavailable_at "2017-10-26 14:58:10"
  end
end
