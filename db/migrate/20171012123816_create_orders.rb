class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.references :designer, index: true, type: :uuid, foreign_key: true
      t.references :user, index: true, type: :uuid, foreign_key: true
      t.references :offer_quotation, index: true, type: :uuid, foreign_key: true
      t.boolean :paid, null: false, default: false
      t.boolean :measurements_given, null: false, default: false
      t.boolean :cancelled, null: false, default: false

      t.timestamps
    end

    add_index :orders, :paid, where: :paid
    add_index :orders, :measurements_given, where: :measurements_given
    add_index :orders, :cancelled, where: :cancelled
  end
end
