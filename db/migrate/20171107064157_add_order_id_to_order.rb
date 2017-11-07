class AddOrderIdToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_id, :string
    add_index :orders, :order_id, unique: true
  end
end
