# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :full_name, :username, :email, :gender, :mobile_number, presence: true
  validates :username, :email, :mobile_number, uniqueness: { case_sensitive: false }
  validates :mobile_number, uniqueness: true, allow_nil: true, length: { in: 11..13 }

  # At least one alphabetic character (the [a-z] in the middle).
  # Does not begin or end with an underscore (the (?!_) and (?<!_) at the beginning and end.
  # May have any number of numbers, letters, or underscores before and after the alphabetic character,
  # but every underscore must be separated by at least one number or letter (the rest).
  validates :username, length: { in: 4..40 },
                       format: { with:    /\A(?!_)(?:[a-z0-9]_?)*[a-z](?:_?[a-z0-9])*(?<!_)\z/i,
                                 message: 'only alphabets, digits and underscores are allowed' }

  validates :full_name, length: { in: 4..60 },
                        format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English alphabets' }

  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'please provide valid email' }

  before_save :downcase_reqd_attrs
  before_create :generate_confirmation_instructions
  after_create :send_confirmation_email

  def self.find_for_auth(login)
    find_by(['lower(email) = :value OR lower(username) = :value', { value: login.downcase }])
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
    self.reset_password_token = SecureRandom.hex(10)
    self.reset_password_token_sent_at = Time.now.getlocal
    save
    RegistrationsMailer.password(self).deliver
  end

  private

  def downcase_reqd_attrs
    self.email = email.strip.downcase
    self.username = username.strip.downcase
    self.mobile_number = mobile_number.strip.downcase
  end

  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.getlocal
  end

  def send_confirmation_email
    RegistrationsMailer.confirmation(self).deliver
  end
end
