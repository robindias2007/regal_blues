class AddSkipCountToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :skip_count, :integer, null: false, default: 0
  end
end
