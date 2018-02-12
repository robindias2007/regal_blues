class CreatePushTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :push_tokens, id: :uuid do |t|
      t.text :token
      t.text :user_id

      t.timestamps
    end
  end
end
