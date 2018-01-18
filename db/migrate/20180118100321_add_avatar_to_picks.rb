class AddAvatarToPicks < ActiveRecord::Migration[5.1]
  def change
    add_column :picks, :avatars, :string, array: true, default: []
  end
end
