# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user
  has_many :requests, dependent: :destroy

  validates :country, :pincode, :street_address, :city, :state, :nickname, presence: true
  validates :street_address, uniqueness: { case_sensitive: false, scope: :user_id }

  before_save :upcase_attrs

  def self.ids_for(user_id)
    where(user_id: user_id).pluck(:id)
  end

  def formatted_address
    "#{street_address}, #{city}, #{state}, #{country}, #{pincode}"
  end

  private

  def upcase_attrs
    self.nickname = nickname.capitalize
    self.city = city.capitalize
    self.state = state.capitalize
    self.country = country.capitalize
  end
end
