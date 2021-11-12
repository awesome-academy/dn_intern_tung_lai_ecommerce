class SessionsController < ApplicationController
  include SessionsHelper
  def cart_index
    fake_cart
    cart_contents
  end

  def cart_add
    cart_add_item
    redirect_to cart_url
  end
end
