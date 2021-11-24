class CartsController < ApplicationController
  def index; end

  def create
    @result = cart_handle_add
    respond_to do |format|
      format.js {}
    end
  end

  def update
    @result = cart_handle_remove
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    remove_item
  end
end
