class AddRoleToSupports < ActiveRecord::Migration[5.1]
  def change
    add_column :supports, :role, :string
  end
end
