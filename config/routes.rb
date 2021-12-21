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

    devise_scope :user do
      get "sign_up", to: "users/registrations#new"
      post "sign_up", to: "users/registrations#create"
      get "sign_in", to: "users/sessions#new"
      post "sign_in", to: "users/sessions#create"
      delete "sign_out", to: "users/sessions#destroy"
    end
    devise_for :users, controllers: { registrations: "users/registrations",
                                      sessions: "users/sessions" }

    resources :products, only: %i(index show)
    resources :carts, except: %i(new show edit)
    resources :orders, only: %i(new create)
  end
end
