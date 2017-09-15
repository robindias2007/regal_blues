class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :country, null: false, default: ''
      t.string :pincode, null: false, default: ''
      t.text :street_address, null: false, default: ''
      t.string :nickname, null: false, default: ''
      t.string :city, null: false, default: ''
      t.string :state, null: false, default: ''
      t.string :landmark
      t.references :user, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
