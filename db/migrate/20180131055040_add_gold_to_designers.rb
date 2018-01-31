class AddGoldToDesigners < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :gold, :boolean, default: false
  end
end
