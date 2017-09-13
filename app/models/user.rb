# frozen_string_literal: true

class User < ApplicationRecord
  include Authenticable
  extend Enumerize

  has_many :user_identities
  has_many :requests

  validates :full_name, :username, :email, :gender, :mobile_number, presence: true
  validates :username, :email, :mobile_number, uniqueness: { case_sensitive: false }

  # At least one alphabetic character (the [a-z] in the middle).
  # Does not begin or end with an underscore (the (?!_) and (?<!_) at the beginning and end.
  # May have any number of numbers, letters, or underscores before and after the alphabetic character,
  # but every underscore must be separated by at least one number or letter (the rest).
  validates :username, length: { in: 4..40 },
                       format: { with:    /\A(?!_)(?:[a-z0-9]_?)*[a-z](?:_?[a-z0-9])*(?<!_)\z/i,
                                 message: 'only alphabets, digits and underscores are allowed' }

  enumerize :gender, in: %i[male female], scope: true, predicates: true

  mount_base64_uploader :avatar, AvatarUploader

  # def self.create_with_facebook(info)
  #   user = new
  #   user_attributes_for_fb(user, info)
  #   user.save
  #   identity = user.user_identities.new
  #   identity.uid = info['id']
  #   identity.provider = 'facebook'
  #   identity.save
  #   user
  # end
  #
  # def self.create_with_google(info)
  #   user = info
  #   user
  # end

  def live_orders?
    # TODO: Update this
    false
  end

  def requests_but_no_orders?
    # requests.present? && orders.nil?
    requests.present?
  end

  def no_requests_or_orders?
    # requests.nil? && orders.nil?
    requests.blank?
  end

  # private
  #
  # # TODO: Update photo from https://graph.facebook.com/v2.10/id/picture?redirect=0&hieght=400&width=400
  # # using a background job
  # def user_attributes_for_fb(user, info)
  #   email = info['email'].nil? ? info['id'] + '@amidos.com' : info['email']
  #   user.full_name = info['name']
  #   user.email = email
  #   user.mobile_number = info['mobile_number']
  #   user.gender = info['gender']
  #   user.avatar = info['cover']['source']
  #   user.password = friendly_password
  #   user.username = SecureRandom.hex(4)
  # end
end
