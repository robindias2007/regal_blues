class AddInvolvedToRequestDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :request_designers, :involved, :boolean, null: false, default: false
    add_index :request_designers, :involved, where: :involved
  end
end
