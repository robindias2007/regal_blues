class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :full_name, null: false, default: ''
      t.string :username, null: false, default: ''
      t.string :mobile_number, null: false, default: ''
      t.string :gender, null: false
      t.string :avatar
      t.string :email, null: false, default: ''
      t.string :password_digest, null: false, default: ''
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.string :reset_password_token
      t.datetime :reset_password_token_set_at
      t.datetime :reset_password_at

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :mobile_number, unique: true
    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
