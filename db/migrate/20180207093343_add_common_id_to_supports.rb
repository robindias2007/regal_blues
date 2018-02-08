class AddCommonIdToSupports < ActiveRecord::Migration[5.1]
  def change
    add_column :supports, :common_id, :string
  end
end
