# frozen_string_literal: true

class RequestImage < ApplicationRecord
  belongs_to :request
  has_many :images, as: :imageable
end
