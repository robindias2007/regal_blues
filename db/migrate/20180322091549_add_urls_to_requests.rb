class AddUrlsToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :urls, :string, array: true, default: []
  end
end
