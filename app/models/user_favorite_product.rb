# frozen_string_literal: true

class UserFavoriteProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
