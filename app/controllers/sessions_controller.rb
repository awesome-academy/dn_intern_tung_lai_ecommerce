class SessionsController < ApplicationController
  before_action :use_layout_auth, only: [:new]
  after_action :wipe_cart, only: [:destroy]

  # fake cart when first logged in only for now
  # will be fixed when Product view is merged
  after_action :fake_cart, only: [:create]

  def new
    redirect_to root_url if current_user.present?
  end

  def create
    @current_user = User.find_by email: params[:user][:email]
    if @current_user&.admin?
      flash[:warning] = t("admins_not_allowed")
      redirect_to action: :new
    elsif @current_user&.authenticate(params[:user][:password])
      handle_log_in
    else
      flash[:danger] = t("email_password_invalid")
      redirect_to action: :new
    end
  end

  def destroy
    if current_user.present?
      session.delete :user_id
      @current_user = nil
      flash[:success] = t("logged_out")
    end
    redirect_to root_url
  end

  private

  def handle_log_in
    remember_user
    flash[:success] = t("logged_in_as", name: @current_user.first_name)
    redirect_to root_url
  end

  def remember_user
    session[:user_id] = @current_user.id
  end

  def use_layout_auth
    @use_layout_auth = true
  end
end
