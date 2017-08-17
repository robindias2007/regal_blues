class CreateProductImages < ActiveRecord::Migration[5.1]
  def change
    create_table :product_images, id: :uuid do |t|
      t.references :product, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
