module Admin::BaseHelper
  def full_title page_title = ""
    base_title = t "app_name"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # def current_user
  #   return nil if (user_id = session[:admin_id]).nil?

  #   @current_user ||= User.find_by id: user_id
  # end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def require_admin_user
    redirect_to admin_login_url unless current_user&.admin?
  end
end
