Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :admin do
      root "static_pages#index"
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      get "logout", to: "sessions#destroy"
      resources :orders, except: %i(create destroy)
    end
    devise_for :users, controllers: {sessions: "sessions"},
                       path: "",
                       path_names: {sign_in: :login, sign_out: :logout,
                                    sign_up: :register}
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    resources :products, only: %i(index show)
    resources :carts, except: %i(new show edit)
    resources :orders, only: %i(new create)
  end
end
