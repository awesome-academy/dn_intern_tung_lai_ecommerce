class Api::V1::AuthenticationController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by(email: params[:email])

    if @user&.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.zone.now + 24.hours.to_i
      render json: {token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                    data: UserSerializer.new(@user).as_json}, status: :ok
    else
      render json: {}, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
