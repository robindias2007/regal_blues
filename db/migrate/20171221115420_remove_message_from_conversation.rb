class RemoveMessageFromConversation < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversations, :message, :text
    remove_column :conversations, :attachment, :string
    remove_column :conversations, :sender_type, :string
  end
end
