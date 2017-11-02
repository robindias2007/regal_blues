class CreateUserFavoriteDesigners < ActiveRecord::Migration[5.1]
  def change
    create_table :user_favorite_designers, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.references :designer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
