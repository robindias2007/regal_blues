class RenameColumnNameForNotification < ActiveRecord::Migration[5.1]
  def change
  	rename_column :notifications, :notification_type, :notificationable_type
  end
end
