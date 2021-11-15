Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"
    get "/help", to: "static_pages#help"
    get "/contact", to: "static_pages#contact"
  end
end
