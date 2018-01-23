class RemoveIndexFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :mobile_number
  end
end
