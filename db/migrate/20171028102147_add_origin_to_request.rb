class AddOriginToRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :origin, :string
    add_index :requests, :origin, using: :gin
  end
end
