class CreateOrderPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :order_payments, id: :uuid do |t|
      t.references :order, type: :uuid, index: true, foreign_key: true
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.integer :price, null: false, default: 0
      t.string :payment_id, null: false, default: ''
      t.boolean :success, null: false, default: false
      t.jsonb :extra, null: false, default: {}

      t.timestamps
    end
  end
end
