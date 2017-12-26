class CreateDesignerChatTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :designer_chat_types, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
