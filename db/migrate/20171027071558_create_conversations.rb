class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :support_chat, type: :uuid, index: true, foreign_key: true
      t.text :message
      t.string :attachment

      t.timestamps
    end
  end
end
