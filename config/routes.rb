Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout
  get "logout" => "sessions#destroy"


  resources :members, only: [:create]
  get "signup" => "members#new", as: :signup

  resources :resumes, only: [:new, :show] do
    member do
      post :generate_summary
    end
  end

  namespace :api do
    namespace :v1 do
      resources :resumes, only: [:show, :create, :update]
      resources :companies, only: [:create, :update]
      resources :positions, only: [:create, :update]
      resources :tasks, only: [:create, :update]
      resources :achievements, only: [:create, :update]
    end
  end
end
