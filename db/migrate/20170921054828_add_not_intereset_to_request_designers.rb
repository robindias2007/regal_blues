class AddNotInteresetToRequestDesigners < ActiveRecord::Migration[5.1]
  def change
    add_column :request_designers, :not_interested, :boolean, null: false, default: false
    add_index :request_designers, :not_interested, where: 'not_interested IS FALSE'
  end
end
