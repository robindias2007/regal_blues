class CreateTopQuerySuggestions < ActiveRecord::Migration[5.1]
  def change
    create_table :top_query_suggestions, id: :uuid do |t|
      t.string :name
      t.integer :serial_no

      t.timestamps
    end
  end
end
