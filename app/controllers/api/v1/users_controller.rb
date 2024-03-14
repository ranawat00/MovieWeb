class Api::V1::UsersController < ApplicationController
  # before_action :authorize_request ,except: [:create]
  # before_action :find_user, except: %i[create index]
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]


  def index
    @users = User.all
    render json: @users,state: :ok
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render json: @user, status: :ok
    else
      render json: { errors: 'User not found' }, status: :not_found
    end
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
    
    @user = User.find_by(id: params[:id])
    if @user
      if @user.update(user_params)
        render json: {user:@user,message: 'User successfully updated' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'User not found' }, status: :not_found
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.present?
      if @user.destroy
        render json: { message: 'User successfully deleted' }, status: :ok
      else 
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "User not found" }, status: :not_found
    end
  end



  private
  def user_params
    params.require(:user).permit(:firstname, :lastname,:username,:password,:email,:password_confirmation, :twofa, :twofa_on_off)
  end


end
