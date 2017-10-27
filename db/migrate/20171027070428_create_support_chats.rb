class CreateSupportChats < ActiveRecord::Migration[5.1]
  def change
    create_table :support_chats, id: :uuid do |t|
      t.references :support, type: :uuid, index: true, foreign_key: true
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.references :designer, type: :uuid, index: true, foreign_key: true
      t.boolean :responding

      t.timestamps
    end
  end
end
