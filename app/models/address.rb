# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user
  has_many :requests

  validates :country, :pincode, :street_address, :city, :state, :nickname, presence: true
  validates :street_address, uniqueness: { case_sensitive: false, scope: :user_id }

  def self.ids_for(user_id)
    where(user_id: user_id).pluck(:id)
  end
end
