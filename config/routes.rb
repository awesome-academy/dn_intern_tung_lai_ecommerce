Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :admin do
      root "static_pages#index"
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      get "logout", to: "sessions#destroy"
      resources :orders, except: %i(create destroy)
    end
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"

    devise_scope :user do
      get "sign_up", to: "users/registrations#new"
      post "sign_up", to: "users/registrations#create"

    end
    devise_for :users, controllers: { registrations: "users/registrations" },
                       skip: %i(sessions)

    resources :products, only: %i(index show)
    resources :carts, except: %i(new show edit)
    resources :orders, only: %i(new create)
  end
end
