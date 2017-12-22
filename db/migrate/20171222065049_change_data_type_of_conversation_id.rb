class ChangeDataTypeOfConversationId < ActiveRecord::Migration[5.1]
  def change
  	change_column :messages, :conversation_id, :text
  end
end
