Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/sign_in")
  get "sign_in", to: "sessions#new", as: "sign_in"
  get "sign_out", to: "sessions#destroy", as: "sign_out"

  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
