# frozen_string_literal: true

class Request < ApplicationRecord
  extend Enumerize
  include PushNotification

  belongs_to :user
  belongs_to :sub_category
  belongs_to :address
  has_many :request_images, dependent: :destroy
  has_many :request_designers, dependent: :destroy
  has_many :offers, dependent: :destroy

  has_one :request_chat, dependent: :destroy

  validates :name, :size, :timeline, :description, presence: true
  # validates :request_images, :request_designers, length: { minimum: 1, maximum: 100 }
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }
  validates :min_budget, numericality: true, allow_nil: true
  validates :max_budget, numericality: { greater_than_or_equal_to: 0,
    less_than: 10_000_000 }
  validates :address, presence: true, if: proc { |req| Address.ids_for(req.user_id) }

  accepts_nested_attributes_for :request_images
  accepts_nested_attributes_for :request_designers

  enumerize :size, in: %w[xs-s s-m m-l l-xl xl-xxl], scope: true, predicates: true
  enumerize :status, in: %i[active pending unapproved], scope: true, predicates: true, default: :active
  enumerize :origin, in: %i[upload search designer]

  def self.find_for(designer)
    joins(:request_designers).where(request_designers: { designer: designer })
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update(:"#{attr}" => false) : update(:"#{attr}" => true)
  end

  def send_request_mail
    self.request_designers.each do |request_designer|
      NotificationsMailer.new_request(self.user, request_designer.designer).deliver_later
      begin
        body = "You have a new request"
        request_designer.designer.notifications.create(body: body, notification_type: "request")
        Request.new.send_notification(request_designer.designer.devise_token, body, body)
      rescue        
      end
    end
  end
end
