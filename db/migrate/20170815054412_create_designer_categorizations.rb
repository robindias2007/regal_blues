class CreateDesignerCategorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :designer_categorizations, id: :uuid do |t|
      t.references :designer, type: :uuid, index: true, foreign_key: true
      t.references :sub_category, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
