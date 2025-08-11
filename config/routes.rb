Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout

  resources :users, only: [:create]
  get "signup" => "users#new", as: :signup

  resources :resumes, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      resources :resumes, only: [:create]
    end
  end
end
