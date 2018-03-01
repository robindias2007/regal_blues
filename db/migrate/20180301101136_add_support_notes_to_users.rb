class AddSupportNotesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :support_notes, :string
  end
end
