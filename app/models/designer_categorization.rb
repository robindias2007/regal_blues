# frozen_string_literal: true

class DesignerCategorization < ApplicationRecord
  belongs_to :designer
  belongs_to :sub_category

  validates :sub_category_id, uniqueness: { scope: :designer_id }

  def self.cat_ids_of_designer(designer_id)
    where(designer_id: designer_id).pluck(:sub_category_id)
  end
end
