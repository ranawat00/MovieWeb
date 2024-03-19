class Api::V1::WatchlatersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]

  def index
    @watchlaters = Watchlater.all
    if @watchlaters.present?
      render json: @watchlaters, status: :ok
    else
      render json: { message: ' watchlaters not found' }, status: :not_found
    end
  end


  def show
    @watchlater = Watchlater.find_by(id: params[:id])
    if @watchlater.present?
      render json: @watchlater, status: :ok
    else
      render json: { message: 'watchlater not found' }, status: :not_found
    end
  end

  def create
    @watchlater = Watchlater.new(watchlater_params)
    if @watchlater.save
      render json: { watchlater: @watchlater, message: 'watchlater successfully created' }, status: :created
    else
      render json: {errors: @watchlater.errors.full_messages , message: 'watchlater not created'}, status: :unprocessable_entity
    end
  end

  def update 
    @watchlater = Watchlater.find_by(id: params[:id])
    if @watchlater.present?
      if @watchlater.update(watchlater_params)
        render json: { watchlater: @watchlater, message: 'watchlater successfully updated' }, status: :ok
      else
        render json: { errors: @watchlater.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'watchlater not found' }, status: :not_found
    end
  end

  def destroy
    @watchlater = Watchlater.find_by(id: params[:id])
    if @watchlater
      if @watchlater.destroy
        render json: { message: 'watchlater successfully deleted' }, status: :ok
      else 
        render json: { errors: @watchlater.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "watchlater not found" }, status: :not_found
    end
  end

  private

  def watchlater_params
    params.require(:watchlater).permit(:watchlater_movie_id, :user_id)
  end
end
