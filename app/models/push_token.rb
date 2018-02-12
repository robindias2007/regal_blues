class PushToken < ApplicationRecord
  belongs_to :user, optional: true
  validates :token,  uniqueness: { case_sensitive: false }
end