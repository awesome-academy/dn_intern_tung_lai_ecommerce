class Admin::SessionsController < Admin::BaseController
  layout "../admin/sessions/base", only: [:new]
  before_action :require_admin_user, except: [:new, :create]

  def new
    redirect_to admin_root_url if current_user
  end

  def create
    @current_user = User.find_by email: params[:login][:email]
    if @current_user&.user?
      flash[:warning] = t("admin.users_not_allowed")
      redirect_to action: :new
    elsif @current_user&.valid_password?(params[:login][:password])
      handle_log_in
    else
      flash[:danger] = t("admin.log_in_failed")
      redirect_to action: :new
    end
  end

  def destroy
    forget_user
    redirect_to admin_login_url
  end

  private

  def handle_log_in
    remember_user
    flash[:success] = t("admin.logged_in_as", name: @current_user.first_name)
    redirect_to admin_root_url
  end

  def remember_user
    session[:admin_id] = @current_user.id
  end

  def forget_user
    return if current_user.nil?

    session.delete :admin_id
    @current_user = nil
  end
end
