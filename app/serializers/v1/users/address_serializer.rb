# frozen_string_literal: true

class V1::Users::AddressSerializer < ActiveModel::Serializer
  attributes :nickname, :formatted_address

  def formatted_address
    "#{object.street_address}, #{object.city}, #{object.state}, #{object.country}, #{object.pincode}"
  end
end
