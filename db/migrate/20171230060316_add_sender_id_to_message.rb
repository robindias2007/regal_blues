class AddSenderIdToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :sender_id, :text
  end
end
