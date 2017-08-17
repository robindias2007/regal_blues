# frozen_string_literal: true

class DesignerCategorization < ApplicationRecord
  belongs_to :designer
  belongs_to :sub_category
  has_many :products
end
