class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.text :body
      t.text :resourceable_id
      t.string :resourceable_type
      t.string :type

      t.timestamps
    end
  end
end
