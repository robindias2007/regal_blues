# frozen_string_literal: true

class Designer < ApplicationRecord
  has_secure_password

  validates :full_name, :email, :mobile_number, :location, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }
  validates :mobile_number, uniqueness: true, allow_nil: true, length: { in: 11..13 }

  validates :full_name, length: { in: 4..60 },
                        format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English alphabets' }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'please provide valid email' }
end
