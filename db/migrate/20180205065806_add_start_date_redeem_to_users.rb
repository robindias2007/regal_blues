class AddStartDateRedeemToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :membership_start_date, :datetime
    add_column :users, :redeem, :boolean, default: false
  end
end
