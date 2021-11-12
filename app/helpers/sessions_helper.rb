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

    return self.cart_contents
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

  def cart_add_item
    @products = cart_contents

    return if @products.empty?

    if session[:cart][params[:id].to_s]
      session[:cart][params[:id].to_s] += 1
    else
      session[:cart][params[:id].to_s] = 1
    end
  end

  def subtotal
    @products = cart_contents
    subtotal = 0
    unless @products.blank?
      @products.each do |pair|
        subtotal += pair[1][:price].to_f * pair[0][1].to_f
      end
    end

    return subtotal.round(2)
  end

  # def build_order
  #   @products = cart_contents
  #   order = []
  #   @products.each do |product|
  #     order << {name: product[0].name,
  #       quantity: product[1]["qty"],
  #       amount: product[0].price.to_i}
  #     end

  #     return order
  #   end

  #   def build_json
  #     cart_session = session[:cart][:products]
  #     json = {:subtotal => self.subtotal.to_f.round(2),
  #       :qty => self.cart_count,
  #       :items => Hash[cart_session.uniq.map {
  #         |i| [i, cart_session.count(i)]
  #       }]}

  #       return json
  #     end

    end
