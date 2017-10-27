class AddActiveStatusToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :live_status, :string
  end
end
