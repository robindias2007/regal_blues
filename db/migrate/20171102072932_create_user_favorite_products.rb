class CreateUserFavoriteProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_favorite_products, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.references :product, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
