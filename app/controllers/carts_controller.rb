class CartsController < ApplicationController
  def index; end

  def create
    @result = cart_handle_add
  end

  def update
    @result = cart_handle_remove
  end

  def destroy
    remove_item
  end
end

private
def item_exists
  Product.exists?(params[:id])
end

# check if current_qty is larger than inventory
def qty_exceeds_range id, qty
  inventory = item_attr :inventory, id
  return true unless inventory

  qty > inventory[0]
end

# increase item quantity from cart by 1
def cart_handle_add
  return false unless item_exists

  possible_qty = session[:cart][params[:id]] || 0
  possible_qty += 1
  return :exceeded if qty_exceeds_range params[:id], possible_qty

  session[:cart][params[:id]] = possible_qty
  :added
end

# subtract item quantity from cart by 1
def cart_handle_remove
  return false unless session[:cart][params[:id]]

  return :pending_remove if session[:cart][params[:id]] == 1

  session[:cart][params[:id]] -= 1
  :removed
end

# remove item from cart
def remove_item
  session[:cart].delete(params[:id]) if session[:cart][params[:id]]
end
