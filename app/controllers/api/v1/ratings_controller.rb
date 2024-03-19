class Api::V1::RatingsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]

  def index
    @ratings = Rating.all
    if @ratings.present?
      render json: @ratings, status: :ok
    else
      render json: { message: "ratings not found" }, status: :not_found
    end
  end

  def show
    @rating = Rating.find_by(id:params[:id])
    if @rating.present?
    render json: @rating, status: :ok
    else
      render json: { message: "rating not found" }, status: :not_found
    end
  end

  def create
    @rating = Rating.new(rating_params)
    if @rating.save
      render json:{rating: @rating,message:"rating created succesfull"},status: :created
    else
      render json: { errors: @rating.errors.full_messages, message: "rating created unsuccessfull" }, status: :unprocessable_entity
    end
  end

  def update 
    @rating = Rating.find_by(id: params[:id])
    if @rating.present?
      if @rating.update(rating_params)
        render json: { rating: @rating, message: 'rating successfully updated' }, status: :ok
      else
        render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'rating not found' }, status: :not_found
    end
  end

  def destroy
    @rating = Rating.find_by(id: params[:id])
    if @rating
      if @rating.destroy
        render json: { message: 'rating successfully deleted' }, status: :ok
      else 
        render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "rating not found" }, status: :not_found
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:user_id, :rating_value, :rating_movie_id)
  end
end

