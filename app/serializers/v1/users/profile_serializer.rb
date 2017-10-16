# frozen_string_literal: true

class V1::Users::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :bio, :member_since, :location, :wishlist, :favorite_designers

  def member_since
    object.created_at.strftime('%Y')
  end

  def location
    address = object.addresses.first
    "#{address.city}, #{address.country}"
  end

  def wishlist
    'not implemented'
  end

  def favorite_designers
    'not implemented'
  end
end
