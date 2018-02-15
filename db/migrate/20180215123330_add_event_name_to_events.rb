class AddEventNameToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :event_name, :string
  end
end
