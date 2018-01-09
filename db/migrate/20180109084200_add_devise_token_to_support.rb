class AddDeviseTokenToSupport < ActiveRecord::Migration[5.1]
  def change
    add_column :supports, :devise_token, :text
  end
end
