Rails.application.routes.draw do
  devise_for :users
  root to: "properties#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "properties/map" => "properties#map", as: 'properties_map'

  resources :properties, only: %i[index show] do
    collection do
      get :search
    end
    post :contact, on: :member
    resources :saved_properties, only: %i[create destroy]
  end

  resources :saved_properties, only: [:index, :show]

  resources :recommendations, only: %i[new index create show destroy]

  resources :locations, only: %i[index]

  resources :contact_form, only: %i[new create]
end
