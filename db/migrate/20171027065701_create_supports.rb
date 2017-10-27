class CreateSupports < ActiveRecord::Migration[5.1]
  def change
    create_table :supports, id: :uuid do |t|
      t.string :full_name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :mobile_number, null: false, default: ''
      t.string :password_digest, null: false, default: ''
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.string :reset_password_token
      t.datetime :reset_password_token_set_at
      t.datetime :reset_password_at

      t.timestamps
    end

    add_index :supports, :email, unique: true
    add_index :supports, :password_digest, unique: true
    add_index :supports, :confirmation_token, unique: true
    add_index :supports, :reset_password_token, unique: true

  end
end
