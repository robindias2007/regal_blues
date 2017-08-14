# frozen_string_literal: true

class UserIdentity < ApplicationRecord
  belongs_to :user

  validates :uid, :provider, presence: true, uniqueness: { case_sensitive: false }
end
