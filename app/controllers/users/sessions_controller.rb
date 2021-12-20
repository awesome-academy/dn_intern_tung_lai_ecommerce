class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params

  protected

  def configure_sign_in_params
    sign_in_params = %i(email password)
    devise_parameter_sanitizer.permit(:sign_in, keys: sign_in_params)
  end
end
