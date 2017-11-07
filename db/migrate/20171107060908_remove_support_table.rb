class RemoveSupportTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :supports, force: :cascade, if_exists: true
  end
end
