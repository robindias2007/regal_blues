class ChangePasswordResetColumnForUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :reset_password_token_set_at, :reset_password_token_sent_at
  end
end
