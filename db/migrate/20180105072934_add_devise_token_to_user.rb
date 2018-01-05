class AddDeviseTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :devise_token, :text
  end
end
