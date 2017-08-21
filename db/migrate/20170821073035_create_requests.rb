class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests, id: :uuid do |t|
      t.string :name, null: false, default: ''
      t.string :size, null: false, default: ''
      t.decimal :min_budget, null: false, default: 0.0, precision: 9, scale: 2
      t.decimal :max_budget, null: false, default: 0.0, precision: 9, scale: 2
      t.integer :timeline, null: false, default: 0
      t.text :description
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.references :sub_category, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :requests, :name, using: :gist
  end
end
