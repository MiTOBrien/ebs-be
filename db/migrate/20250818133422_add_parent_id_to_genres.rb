class AddParentIdToGenres < ActiveRecord::Migration[8.0]
  def change
    add_reference :genres, :parent, foreign_key: { to_table: :genres }, index: true
  end
end
