class CreateSupportChats < ActiveRecord::Migration[5.1]
  def change
    create_table :support_chats, id: :uuid do |t|
      t.references :support, type: :uuid
      t.references :user, type: :uuid
      t.references :designer, type: :uuid
      t.boolean :responding

      t.timestamps
    end
  end
end
