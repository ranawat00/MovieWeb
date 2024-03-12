class Api::V1::WatchlatersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]

  def index 
    @watchlaters = Watchlater.all
    render json: @watchlaters
  end

  def show
    @watchlater = Watchlater.find(params[:id])
    if @watchlater
      render json: @watchlater
    else
      render json: {error: "result not found"}, status: :unprocessable_entity
    end
  end

  def create
    @watchlater = Watchlater.new(watchlater_params)
    if @watchlater.save
      render json: {watchlater:@watchlater,message: 'watchlater successfully created'}, status: :created
    else
      render json: {errors: @watchlater.errors.full_messages,message:'not created'}, status: :unprocessable_entity
    end
  end

  def update
    @watchlater = Watchlater.find(params[:id])
    if @watchlater.update(watchlater_params)
      render json: {watchlater: @watchlater,message: 'watchlater successfully updated'}, status: :ok
    else
      render json: {errors: @watchlater.errors.full_messages,message:'not updated'}, status: :unprocessable_entity
    end
  end

  def destroy
    @watchlater = Watchlater.find(params[:id])
    if @watchlater.destroy
      render json: {watchlater: @watchlater,message: 'movie deleted from your watchlater'}, status: :ok
    else
      render json: {errors: @watchlater.errors.full_messages,message:'not destroyed'}, status: :unprocessable_entity
    end
  end

  private

  def watchlater_params
    params.require(:watchlater).permit(:watchlater_movie_id, :user_id)
  end
end
