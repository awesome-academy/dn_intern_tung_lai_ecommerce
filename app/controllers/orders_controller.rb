class OrdersController < ApplicationController
  before_action :please_login, unless: :is_logged_in?
  before_action :please_buy_more, if: :cart_is_empty?
  before_action :check_valid_params, only: :create
  after_action :empty_cart, only: :create

  def new; end

  def create
    @order = @current_user.orders.build order_params
    ActiveRecord::Base.transaction do
      @order.save!
    end

    flash[:success] = t "order.succeeded"
    redirect_to products_path
  rescue StandardError
    flash[:error] = t "order.error"
    redirect_to carts_path
  end

  private

  def order_params
    params[:order][:total_price] = subtotal
    params.require(:order)
          .permit(:total_price,
                  order_items_attributes: [:product_id,
                                           :quantity])
  end

  def please_login
    flash[:warning] = t "cart.please_login"
    redirect_to new_user_session_path
  end

  def please_buy_more
    flash[:warning] = t "cart.buy_more"
    redirect_to products_path
  end

  def parse_order_items
    params[:order][:order_items_attributes] =
      JSON.parse(params[:order][:order_items_attributes])
  end

  def check_valid_params
    unvalid_product = []
    unvalid_qty = []
    parse_order_items
    params.dig(:order, :order_items_attributes).each do |order_item|
      product = Product.find_by id: order_item["product_id"]
      unvalid_product << product && next unless product
      unvalid_qty << product.name if product.inventory < order_item["quantity"]
    end
    show_unvalid_products unvalid_product && return if unvalid_product.any?
    show_unvalid_qty unvalid_qty if unvalid_qty.any?
  end

  def show_unvalid_products products
    flash[:warning] = t("order.unvalid_product", products: products)
    redirect_to carts_path
  end

  def show_unvalid_qty products
    flash[:warning] = t("order.unvalid_quantities", products: products)
    redirect_to carts_path
  end
end
