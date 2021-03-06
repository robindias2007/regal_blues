# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    has_secure_password

    validates :full_name, length: { in: 4..60 },
                          format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English alphabets' }

    validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'please provide valid email' }
    validates :password, length: { minimum: 8 }, if: -> { password.present? }
    #validates :mobile_number, uniqueness: true, allow_nil: true, length: { in: 10..14 }

    before_save :downcase_reqd_attrs
    before_create :generate_confirmation_instructions
    # after_create :send_confirmation_email
    # :send_otp

    def support?
      current_support
    end

    def confirmed?
      confirmed_at.present?
    end

    def valid_confirmation_token?
      (confirmation_sent_at + 30.days) > Time.now.getlocal
    end

    def mark_as_confirmed!
      self.confirmation_token = nil
      self.confirmed_at = Time.now.getlocal
      save
    end

    def valid_reset_password_token?
      (reset_password_token_sent_at + 6.hours) > Time.now.getlocal
    end

    def update_reset_details!
      self.reset_password_token = nil
      self.reset_password_at = nil
      save
    end

    def send_reset_password_instructions
      self.reset_password_token = SecureRandom.urlsafe_base64(15)
      self.reset_password_token_sent_at = Time.now.getlocal
      save
      RegistrationsMailer.password(self).deliver_later
    end

    def friendly_password(length = 20)
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    end

    def send_otp
      otp = Array.new(6) { rand(10) }.join
      Redis.current.set(id, otp)
      Rails.logger.debug otp
      SmsService.send_otp_to(self, otp)
    end

    private

    def downcase_reqd_attrs
      self.email = email.strip.downcase
      self.username = username.strip.downcase if self.class.has_attribute?('username')
      self.mobile_number = mobile_number.strip.downcase
    end

    def generate_confirmation_instructions
      self.confirmation_token = SecureRandom.urlsafe_base64(15)
      self.confirmation_sent_at = Time.now.getlocal
    end

    def send_confirmation_email
      RegistrationsMailer.confirmation(self).deliver_later
    end
  end

  module ClassMethods
    def find_for_auth(login)
      query = if name == 'User'
                'lower(email) = :value OR lower(username) = :value'
              else
                'lower(email) = :value'
              end
      find_by([query, { value: login&.downcase }])
    end
  end
end
