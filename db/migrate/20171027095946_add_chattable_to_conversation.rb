class AddChattableToConversation < ActiveRecord::Migration[5.1]
  def change
    add_reference :conversations, :chattable, polymorphic: true, type: :uuid, index: true
    add_reference :conversations, :personable, polymorphic: true, type: :uuid, index: true
    remove_reference :conversations, :support_chat
  end
end
