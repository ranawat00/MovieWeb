class Api::V1::AuthenticationController < ApplicationController
  # before_action :authorize_request,except:[:login ]
  skip_before_action :verify_authenticity_token,only:[:login, :forgot_password]

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def forgot_password
    debugger
    @user = User.find_by_email(params[:email])
    if @user
      @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render json: { message: 'Password reset successfully' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  
  private
  
  def login_params
    params.permit(:email, :password_digest)
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
 
