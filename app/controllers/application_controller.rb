class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CategoriesHelper
  include CartsHelper

  protect_from_forgery with: :exception

  before_action :set_locale, :init_cart
end
