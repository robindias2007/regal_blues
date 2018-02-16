class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :resource_type
      t.string :username	
      t.string :param1
      t.string :param2
      t.string :param3
      t.string :param4
      t.string :param5
      t.string :param6
      t.string :param7 
      t.string :param8
      t.string :param9
      t.string :param10

      t.timestamps
    end
  end
end
