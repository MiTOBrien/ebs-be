class GenresController < ApplicationController
  before_action :authenticate_user!

  def index
    top_level_genres = Genre.where(parent_id: nil).includes(:subgenres)
    render json: top_level_genres.as_json(include: :subgenres)
  end
end