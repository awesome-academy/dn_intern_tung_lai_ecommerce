Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    get "/help", to: "static_pages#help"
    get "/contact", to: "static_pages#contact"

    get "/cart", to: "cart#index"
    get "cart" => "sessions#cart_index"
    get "cart/add/:id" => "sessions#cart_add", :as => "cart_add"
    delete "cart/remove/(/:id(/:all))" => "session#cart_delete"
  end
end
