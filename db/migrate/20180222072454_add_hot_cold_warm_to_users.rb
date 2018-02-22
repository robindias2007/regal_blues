class AddHotColdWarmToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :hot, :boolean
    add_column :users, :cold, :boolean
    add_column :users, :warm, :boolean
  end
end
