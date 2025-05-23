Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#new"

  resources :users, only: [:new, :create]
end
