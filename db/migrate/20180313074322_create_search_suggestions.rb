class CreateSearchSuggestions < ActiveRecord::Migration[5.1]
  def change
    create_table :search_suggestions, id: :uuid do |t|
      t.string :name
      t.integer :serial_no

      t.timestamps
    end
  end
end
