class ProductsController < ApplicationController
  before_action :filter_products, only: :index
  before_action :load_product_or_redirect, :related_products, only: :show

  def index
    @products_found = @products.count
    @products = @products.page(params[:page])
  end

  def show; end

  private

  def load_product_or_redirect
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:warning] = t("product_not_found")
    redirect_to products_url
  end

  def related_products
    @related_products = Product.related_products(@product)
                               .limit(Settings.paginate.per_page)
  end

  def filter_products
    @query = Product.ransack(params[:filters])
    @products = @query.result
  end
end
