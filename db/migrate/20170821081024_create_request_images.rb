class CreateRequestImages < ActiveRecord::Migration[5.1]
  def change
    create_table :request_images, id: :uuid do |t|
      t.references :request, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
