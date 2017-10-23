class AddDisabledToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :disabled, :boolean, null: false, default: false
  end
end
