# frozen_string_literal: true

class User < ApplicationRecord
  include Authenticable
  include ActiveModel::Dirty

  extend Enumerize

  has_many :user_identities, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_payments, dependent: :nullify

  has_one :support_chat, dependent: :destroy
  has_many :request_chats, dependent: :destroy
  has_many :offer_quotation_chats, dependent: :destroy

  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'

  has_many :user_favorite_products, dependent: :destroy
  has_many :user_favorite_designers, dependent: :destroy
  has_many :products, through: :user_favorite_products, dependent: :destroy
  has_many :designers, through: :user_favorite_designers, dependent: :destroy

  has_many :conversations, as: :conversationable

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

  after_create :send_welcome_email

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

  # Uncomment second line and replace `find_by` with `where` if you want a list of users instead of just one user
  def self.search_for(query)
    find_by('similarity(email, ?) > 0.15', query)
    # .order("similarity(email, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def live_orders?
    # TODO: Update this
    orders.present?
    # false
  end

  def requests_but_no_orders?
    # requests.present? && orders.nil?
    requests.present?
  end

  def no_requests_or_orders?
    # requests.nil? && orders.nil?
    requests.blank?
  end

  def autocompleter
    ["#{full_name} (#{email})", nil]
  end

  def as_request_json
    self.requests.collect{|request| {
      id: request.id,
      name: request.name,
      size: request.size,
      min_budget: request.min_budget,
      max_budget: request.max_budget,
      timeline: request.timeline,
      description: request.description,
      user_id: request.user_id,
      sub_category_id: request.sub_category_id,
      created_at: request.created_at,
      updated_at: request.updated_at,
      address_id: request.address_id,
      status: request.status,
      origin: request.origin,
      message_count: self.conversations.where(receiver_id: request.id)[0].try(:messages).try(:count) 
    }}
  end

  def as_order_json
    self.orders.collect{|order| {
      id: order.id,
      designer_id: order.designer_id,
      user_id: order.user_id,
      offer_quotation_id: order.offer_quotation_id,
      status: order.status,
      order_id: order.order_id,
      created_at: order.created_at,
      updated_at: order.updated_at,
      message_count: self.conversations.where(receiver_id: order.id)[0].try(:messages).try(:count)
    }}
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

  private

  def send_welcome_email
    NotificationsMailer.send_email(self).deliver
  end

end
