class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.text :body
      t.string :attachment
      t.integer :conversation_id

      t.timestamps
    end
  end
end
