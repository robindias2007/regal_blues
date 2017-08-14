class CreateDesigners < ActiveRecord::Migration[5.1]
  def change
    create_table :designers, id: :uuid do |t|
      t.string :full_name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :password_digest, null: false, default: ''
      t.string :mobile_number, null: false, default: ''
      t.string :location, null: false, default: ''
      t.string :avatar
      t.boolean :available, null: false, default: true
      t.string :pin
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.string :reset_password_token
      t.datetime :reset_password_token_sent_at
      t.datetime :reset_password_at
      t.boolean :verified, null: false, default: false

      t.timestamps
    end
    add_index :designers, :email, unique: true
    add_index :designers, :mobile_number, unique: true
    add_index :designers, :confirmation_token, unique: true
    add_index :designers, :reset_password_token, unique: true
  end
end
