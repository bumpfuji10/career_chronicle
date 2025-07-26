Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"

  resources :users, only: [:create]
  get "signup" => "users#new", as: :signup

  resources :resumes, only: [:new, :create]
end
