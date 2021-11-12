class ApplicationController < ActionController::Base
  include SessionsHelper
  include CategoriesHelper

  before_action :set_locale, :fake_cart
  protect_from_forgery with: :exception
  def default_url_options
    {locale: I18n.default_locale}
  end
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
