class Api::V1::WatchlistsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]


  def index
    @watchlists = Watchlist.all
    render json: @watchlists
  end

  def show
    @watchlist = Watchlist.find(params[:id])
    if @watchlist
      render json: @watchlist
    else
      render json:{message: 'watchlist not found'}, status: :unprocessable_entity
    end
  end

  def create
    @watchlist = Watchlist.new(watchlist_params)
    if @watchlist.save
      render json: { watchlist: @watchlist, message: 'Watchlist was successfully created' }, status: :created
    else
      render json: {errors: @comment.errors.full_messages , message: 'watchlist not created'},status: :unprocessable_entity
    end
  end

  def update 
    @watchlist = Watchlist.find(params[:id])
    if @watchlist.update(watchlist_params)
      render json: { watchlist: @watchlist, message: 'Watchlist was successfully updated' }, status: :ok
    else
      render json: {errors: @watchlist.errors.full_messages, message: 'watchlist not updated'},status: :unprocessable_entity
    end
  end

  def destroy
    @watchlist = Watchlist.find(params[:id])
    if @watchlist.destroy
      render json: { watchlist:@watchlist,message: 'Watchlist was successfully destroyed' }, status: :ok
    else
      render json: {errors: @watchlist.errors.full_messages, message: 'watchlist not destroyed'},status: :unprocessable_entity
    end
  end



  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :watchlist_movie_id)
  end



end
