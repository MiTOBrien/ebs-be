class GenresController < ApplicationController
  before_action :authenticate_user!

  def index
    top_level_genres = Genre.where(parent_id: nil).includes(:subgenres)
    render json: top_level_genres.as_json(include: :subgenres)
  end

  def create
    genre = Genre.new(genre_params)

    if genre.save
      render json: genre, status: :created
    else
      render json: { errors: genre.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    genre = Genre.find(params[:id])

    if genre.update(genre_params)
      render json: genre, status: :ok
    else
      render json: { errors: genre.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name, :parent_id)
  end
end