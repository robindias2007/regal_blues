class AddConversationableIdAndConversationableTypeToConversation < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :conversationable_id, :text
    add_column :conversations, :conversationable_type, :string
  end
end
