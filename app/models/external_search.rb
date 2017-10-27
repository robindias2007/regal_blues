# frozen_string_literal: true

class ExternalSearch < ApplicationRecord
  validates :query, presence: true, uniqueness: { case_sensitive: false }
end
