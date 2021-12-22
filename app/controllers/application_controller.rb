class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CategoriesHelper
  include CartsHelper
  include SessionsHelper

  before_action :set_locale, :init_cart
  helper_method :current_user
  protect_from_forgery with: :exception
end
