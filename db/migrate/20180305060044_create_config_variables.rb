class CreateConfigVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :config_variables, id: :uuid do |t|
      t.string :event_name
      t.string :param1
      t.string :param2
      t.string :param3
      t.string :param4

      t.timestamps
    end
  end
end
