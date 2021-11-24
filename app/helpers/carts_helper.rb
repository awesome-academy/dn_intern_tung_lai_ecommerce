module CartsHelper
  # fake the cart only once since the session start, only for now
  def fake_cart
    return if session[:cart] == {} || session[:cart].present?

    session[:cart] = {}
    session[:cart][1.to_s] = 1
    session[:cart][2.to_s] = 2
    session[:cart][3.to_s] = 4
    session[:cart][4.to_s] = 3
  end

  # number of available items in cart
  def cart_count
    return 0 if session[:cart].blank?

    cnt = 0
    session[:cart].each do |pair|
      cnt += Product.exists?(id: pair[0]) ? 1 : 0
    end

    cnt
  end

  # sum of all items
  def subtotal
    subtotal = 0
    if session[:cart].present?
      session[:cart].each do |pair|
        curr_price = item_attr :price, pair[0]
        subtotal += curr_price.any? ? curr_price[0] * pair[1] : 0
      end
    end

    subtotal.round(2)
  end

  # retrived items list exists in cart
  def cart_contents
    products_contents = {}
    session[:cart].each do |pair|
      product = basic_product_info pair[0]
      if product
        session[:cart][pair[0]] = available_qty pair[1], product[:inventory]
        products_contents[pair] = product
      else
        session[:cart].delete(pair[0])
      end
    end

    products_contents
  end

  # increase item quantity from cart by 1
  def cart_handle_add
    return false unless item_exists

    possible_qty = session[:cart][params[:id]] || 0
    possible_qty += 1
    return :exceeded if qty_exceeds_range params[:id], possible_qty

    session[:cart][params[:id]] = possible_qty
  end

  # subtract item quantity from cart by 1
  def cart_handle_remove
    return false unless session[:cart][params[:id]]

    return :pending_remove if session[:cart][params[:id]] == 1

    session[:cart][params[:id]] -= 1
  end

  # remove item from cart
  def remove_item
    session[:cart].delete(params[:id]) if session[:cart][params[:id]]
  end

  private
  def item_exists
    Product.exists?(params[:id])
  end

  def item_attr attr, id
    Product.pluck_attr id, attr
  end

  def basic_product_info id
    Product.basic_product_info id
  end

  # current_qty cannot be larger than inventory
  def available_qty qty, inventory
    qty > inventory ? inventory : qty
  end

  # check if current_qty is larger than inventory
  def qty_exceeds_range id, qty
    inventory = item_attr :inventory, id
    return true unless inventory

    qty > inventory[0]
  end
end
