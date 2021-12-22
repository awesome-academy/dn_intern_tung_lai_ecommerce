class SessionsController < Devise::SessionsController
  include ApplicationHelper
  before_action :use_layout_auth
  before_action :deny_admins, only: :create

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  def deny_admins
    user = User.find_by email: params[:user][:email]
    return if user.nil? || user.user?

    flash[:warning] = t("admins_not_allowed")
    render :new
  end
end
