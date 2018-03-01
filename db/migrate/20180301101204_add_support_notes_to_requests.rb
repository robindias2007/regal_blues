class AddSupportNotesToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :support_notes, :string
  end
end
