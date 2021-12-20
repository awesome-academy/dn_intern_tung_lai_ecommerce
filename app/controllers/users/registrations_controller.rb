class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  protected

  def configure_sign_up_params
    sign_up_params = %i(first_name
                        last_name
                        email
                        password
                        password_confirmation)
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_params)
  end

  def after_sign_up_path_for _resource
    new_user_session_path
  end

  def after_inactive_sign_up_path_for _resource
    new_user_session_path
  end
end
