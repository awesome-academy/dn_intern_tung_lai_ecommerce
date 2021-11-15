module SessionsHelper
  def init_cart
    session[:cart] ||= {}
    @products = {}
  end

  def fake_cart
    init_cart
    session[:cart][1.to_s] = 1
    session[:cart][2.to_s] = 2
    session[:cart][3.to_s] = 4
    session[:cart][4.to_s] = 3
  end

  def cart_count
    return 0 if session[:cart].empty?

    # why hash.keys.count faster than hash.count
    session[:cart].keys.count
  end

  def cart_contents
    @products = session[:cart]

    return if @products.empty?

    # retrive product info by id (pair.key = item id, pair.value = item quantity)
    products_contents = {}
    @products.each do |pair|
      products_contents[pair] = Product.find_by_id(pair[0])
    end

    return products_contents
  end

  def subtotal
    @products = cart_contents
    subtotal = 0
    if @products.present?
      @products.each do |pair|
        subtotal += pair[1][:price].to_f * pair[0][1].to_f
      end
    end

    subtotal.round(2)
  end
end
