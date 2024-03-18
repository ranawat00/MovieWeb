class Api::V1::WatchlistsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]


  def index
    @watchlists = Watchlist.all
    if @watchlists.present?
      render json: @watchlists, status: :ok
    else
      render json: { message: ' watchlists not found' }, status: :not_found
    end
  end

  def show
    @watchlist = Watchlist.find_by(id: params[:id])
    if @watchlist.present?
      render json: @watchlist, status: :ok
    else
      render json: { message: 'Watchlist not found' }, status: :not_found
    end
  end
  

  def create
    @watchlist = Watchlist.new(watchlist_params)
    if @watchlist.save
      render json: { watchlist: @watchlist, message: 'Watchlist successfully created' }, status: :created
    else
      render json: {errors: @watchlist.errors.full_messages , message: 'watchlist not created'}, status: :unprocessable_entity
    end
  end
 
  def update 
    @watchlist = Watchlist.find_by(id: params[:id])
    if @watchlist.present?
      if @watchlist.update(watchlist_params)
        render json: { watchlist: @watchlist, message: 'watchlist successfully updated' }, status: :ok
      else
        render json: { errors: @watchlist.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'watchlist not found' }, status: :not_found
    end
  end

  def destroy
    @watchlist = Watchlist.find_by(id: params[:id])
    if @watchlist
      if @watchlist.destroy
        render json: { message: 'watchlist successfully deleted' }, status: :ok
      else 
        render json: { errors: @watchlist.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "watchlist not found" }, status: :not_found
    end
  end
  

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :watchlist_movie_id)
  end
end
