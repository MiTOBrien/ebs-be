class UserSubgenre < ApplicationRecord
  belongs_to :user_genre
  belongs_to :subgenre, class_name: "Genre"
end
