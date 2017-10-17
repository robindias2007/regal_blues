class ChangeOrderSchema < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :paid, :boolean
    remove_column :orders, :measurements_given, :boolean
    remove_column :orders, :cancelled, :boolean

    add_column :orders, :status, :string
    add_index :orders, :status, using: :gin
  end
end
