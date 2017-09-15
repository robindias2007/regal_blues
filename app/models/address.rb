# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :country, :pincode, :street_address, :city, :state, :nickname, presence: true
  validates :street_address, uniqueness: { case_sensitive: false, scope: :user_id }
end
