# frozen_string_literal: true

FactoryGirl.define do
  factory :designer_finance_info do
    bank_name Faker::Bank.name
    bank_branch Faker::Address.city
    ifsc_code Faker::Bank.swift_bic
    account_number { Faker::Number.number(10) }
    blank_cheque_proof 'Some url string'
    personal_pan_number { Faker::Company.australian_business_number }
    personal_pan_number_proof 'Some url string'
    business_pan_number { Faker::Company.australian_business_number }
    business_pan_number_proof 'Some url string'
    tin_number { Faker::Company.australian_business_number }
    tin_number_proof 'Some url string'
    gstin_number { Faker::Company.australian_business_number }
    gstin_number_proof 'Some url string'
    business_address_proof 'Some url string'
    designer
  end
end
