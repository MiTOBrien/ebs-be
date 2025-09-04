class CreateUserSubgenres < ActiveRecord::Migration[8.0]
  def change
    create_table :user_subgenres do |t|
      t.references :user_genre, null: false, foreign_key: true
      t.references :subgenre, foreign_key: { to_table: :genres }


      t.timestamps
    end
  end
end
