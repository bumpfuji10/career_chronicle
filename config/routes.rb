Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout
  get "logout" => "sessions#destroy"


  resources :members, only: [:create]
  get "signup" => "members#new", as: :signup

  resources :resumes, only: [:new, :create, :show, :index]

  namespace :api do
    namespace :v1 do
      resources :resumes, only: [:create]
      resources :career_profiles, only: [:create, :show] do
        resources :work_experiences, only: [:create, :show, :update] do
          resources :tasks, only: [:create, :update, :destroy]
          resources :improvements, only: [:create, :update, :destroy]
          resources :achievements, only: [:create, :update, :destroy]

          member do
            post :generate_summary
          end
        end
      end
    end
  end
end
