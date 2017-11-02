# frozen_string_literal: true

class UserFavoriteDesigner < ApplicationRecord
  belongs_to :user
  belongs_to :designer
end
