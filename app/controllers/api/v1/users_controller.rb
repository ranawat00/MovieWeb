class Api::V1::UsersController < ApplicationController
  # before_action :authorize_request ,except: [:create]
  # before_action :find_user, except: %i[create index]
  skip_before_action :verify_authenticity_token, only: [:create,:destroy]


  def index
    @users = User.all
    render json: @users,state: :ok
  end

  def show
    @user =User.find(params[:id])
    @user? (render json: @user):(render json: {errors:'User not found'})
  end

  def create
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, user_details: @user.as_json(except: [:password]) }, status: :created
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update 
    
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { message: 'User successfully deleted' }, status: :ok
    else 
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private
  def user_params
    params.require(:user).permit(:firstname, :lastname,:username,:password,:email,:password_confirmation, :twofa, :twofa_on_off)
  end


end
