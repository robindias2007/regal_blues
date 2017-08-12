class CreateUserIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_identities, id: :uuid do |t|
      t.string :uid, null: false, default: ''
      t.string :provider, null: false, default: ''
      t.references :user, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :user_identities, %i[uid provider], unique: true
  end
end
