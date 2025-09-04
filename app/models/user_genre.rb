class UserGenre < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  
  has_many :user_subgenres, dependent: :destroy
  has_many :subgenres, through: :user_subgenres, source: :subgenre
  
  validates :user_id, uniqueness: { scope: :genre_id }
end