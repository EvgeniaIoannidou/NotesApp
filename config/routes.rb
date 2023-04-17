Rails.application.routes.draw do
  root to: "home#index"

  # Define routes for login/logout/signup
  get "logout", to: "session#destroy", as: "logout"
  get "login", to: "session#new", as: "login"
  post "login", to: "session#create"
  get "signup", to: "users#new", as: "signup"
  post "signup", to: "users#create"
  get 'users', to: 'users#index'

  # Define resources for notes
  resources :notes

  # Define resources for users and sessions
  resources :users, except: [:index]
  resources :sessions, only: [:create]
end
