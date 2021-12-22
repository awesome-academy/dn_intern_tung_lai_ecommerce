module API
  module V1
    class Orders < Grape::API
      include API::V1::SharedConcern

      resources :orders do
        get "" do
          orders = Order.ransack(:q).result
          page = orders.page(params[:page])
          error!({error: "Out of page"}, 400) if page.out_of_range?

          {total_pages: page.total_pages, per_page: page.limit_value,
           current_page: page.current_page, next_page: page.next_page,
           previous_page: page.prev_page, count: page.length, orders: page}
        end
        post "" do
          "Create orders"
        end
        get ":id" do
          order = Order.find_by id: params[:id]
          error!({error: "Order not found"}, 404) if order.nil?

          order
        end
        put ":id" do
          "Update orders"
        end
        delete ":id" do
          "Delete orders"
        end
      end
    end
  end
end
