class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :use_layout_auth

  def new
    super
  end

  def create
    super
  end

  protected

  def configure_sign_up_params
    sign_up_params = %i(first_name
                        last_name
                        email
                        password
                        password_confirmation)
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_params)
  end

  def after_sign_up_path_for
    new_user_session_path
  end

  def after_inactive_sign_up_path_for
    new_user_session_path
  end

  private

  def use_layout_auth
    @use_layout_auth = true
  end
end
