class AddHotColdWarmToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :hot, :boolean
    add_column :requests, :cold, :boolean
    add_column :requests, :warm, :boolean
  end
end
