class AddStatusToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :status, :string
  end
end
