class AddVerfiedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :verified, :boolean, default: true
    # add_index :users, :verified, where: :verified
  end
end
