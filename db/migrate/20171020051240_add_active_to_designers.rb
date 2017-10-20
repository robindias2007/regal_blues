class AddActiveToDesigners < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :active, :boolean
    add_column :designers, :bio, :text

    add_index  :designers, :active, where: :active
  end
end
