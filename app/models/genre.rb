class Genre < ApplicationRecord
  has_many :user_genres, dependent: :destroy
  has_many :users, through: :user_genres

  belongs_to :parent, class_name: 'Genre', optional: true
  has_many :subgenres, class_name: 'Genre', foreign_key: 'parent_id', dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
end