class ChangeColumnNamesInConversation < ActiveRecord::Migration[5.1]
  def change
    rename_column :conversations, :chattable_type, :sender_type
    rename_column :conversations, :chattable_id, :sender_id
    rename_column :conversations, :personable_type, :receiver_type
    rename_column :conversations, :personable_id, :receiver_id
  end
end
