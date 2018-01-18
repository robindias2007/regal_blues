class CreatePicks < ActiveRecord::Migration[5.1]
  def change
    create_table :picks, id: :uuid do |t|
      t.string :cat_name
      t.string :keywords

      t.timestamps
    end
  end
end
