Rails.application.routes.draw do
  root to: "home#index"

  # Define routes for login/logout/signup
  get "logout", to: "session#destroy", as: "logout"
  get "login", to: "session#new", as: "login"
  post "login", to: "session#create"
  get "signup", to: "users#new", as: "signup"
  post "signup", to: "users#create"

  resources :users

  # Define resources for notes
  resources :notes

  resources :note_collections do
    member do
      post :add_note
      delete :remove_note
    end
  end

  resources :notes do
    member do
      post :share_note
    end
  end
end
