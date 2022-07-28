Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    root "static_pages#home"
    resources :users, only: %i(new create show edit)
    get "/login", to:"sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
