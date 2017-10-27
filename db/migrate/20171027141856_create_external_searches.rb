class CreateExternalSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :external_searches, id: :uuid do |t|
      t.string :query
      t.integer :count

      t.timestamps
    end
    add_index :external_searches, :query, unique: true
  end
end
