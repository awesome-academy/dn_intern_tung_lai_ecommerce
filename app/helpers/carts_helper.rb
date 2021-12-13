module CartsHelper
  # init cart only once
  def init_cart
    session[:cart] ||= {}
  end

  # wipe out all data in cart when logged out
  def empty_cart
    session[:cart] = {}
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
      if product && product[:inventory].positive?
        session[:cart][pair[0]] = available_qty pair[1], product[:inventory]
        products_contents[pair] = product
      else
        session[:cart].delete(pair[0])
      end
    end

    products_contents
  end

  def cart_is_empty?
    cart_count.zero?
  end

  private
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
end
