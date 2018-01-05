class AddDeviseTokenToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :devise_token, :text
  end
end
