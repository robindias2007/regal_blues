# frozen_string_literal: true

class Offer < ApplicationRecord
  MAX_QUOTES = 3

  belongs_to :designer
  belongs_to :request

  has_many :offer_quotations, dependent: :destroy
  has_many :notifications, as: :notificationable

  # validates :designer_id, uniqueness: { scope: :request_id }
  validates :designer_id, :request_id, presence: true
  validate :max_number_of_quotations
  validate :check_for_time

  accepts_nested_attributes_for :offer_quotations, allow_destroy: true

  def self.find_for_user(user)
    joins(:request).where(requests: { user: user })
  end

  def self.find_for_user_and_request(user, request_id)
    joins(:request).where(requests: { user: user, id: request_id })
  end

  def self.as_json(offers, current_resource)
    offers.collect{|offer| {
      id: offer.id,
      designer_id: offer.designer_id,
      request_id: offer.request_id,
      created_at: offer.created_at,
      updated_at: offer.updated_at,
      offer_quotations: offer.offer_quotations.collect{|quotation| {
        id: quotation.id,
        price: quotation.price,
        description: quotation.description,
        message_count: offer.msg_count(current_resource, quotation),
        unread_message_count: offer.unread_msg_count(current_resource, quotation),
        created_at: quotation.created_at,
        updated_at: quotation.updated_at
      }}
    }}
  end

  def msg_count(res, quotation)
    return res.conversations.where(receiver_id: quotation.id)[0].messages.count rescue 0
  end

  def unread_msg_count(res, quotation)
    return res.conversations.where(receiver_id: quotation.id)[0].messages.where(read: false).count rescue 0
  end

  def update_shipping_price
    if self.request.address.country == "India" || self.request.address.country == "india"
      self.request.update(updated_at:DateTime.now)
      self.offer_quotations.each do |oq|
        oq.update(shipping_price: 300)
      end
    else
      self.request.update(updated_at:DateTime.now)
      self.offer_quotations.each do |oq|
        oq.update(shipping_price: 2000)
      end
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      column_names = %w(created_at)
      csv.add_row %W[ Date #{"Designer Name"} #{"User Username"} #{"Request Name"} #{"Sub Category"} #{"No. of Quotations"}]
      all.each do |offer|
        row = offer.attributes.values_at(*column_names)
        row << offer.designer.full_name
        row << offer.request.user.username
        row << offer.request.name
        row << offer.request.sub_category.name
        row << 
          if offer.offer_quotations.present?
            offer.offer_quotations.count
          else
            0
          end
        csv << row
      end
    end
  end

  private

  def max_number_of_quotations
    errors.add(:offer_quotations, "More than #{MAX_QUOTES} quotations can't be accepted") if
      offer_quotations.size > MAX_QUOTES
  end

  def check_for_time
    errors.add(:designer_id, "Can't accept this offer as the time has exceeded") if time_expired_to_create_offer?
  end

  def time_expired_to_create_offer?
    rd = RequestDesigner.find_by(designer: designer, request: request)
    (rd.involved == true) && (rd.updated_at < (Time.zone.now - 960.hours))
  end
end
