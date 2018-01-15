class AddColumnToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :notificationable_id, :text
  end
end
