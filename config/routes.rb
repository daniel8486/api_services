Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # post "signup", to: "api/v1/users#create"

  namespace :api do
    namespace :v1 do
      post "refresh_token", to: "sessions#refresh_token"

      resources :users

      resources :cities do
        collection do
          post :search_by_cep
          post :search_by_acronym
          get :search
        end
      end

      resources :companies, only: [ :create ]

      resources :clients

      get "is_valid_token", to: "sessions#is_valid_token"
      match "*unmatched", to: "errors#not_found", via: :all
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  match "*unmatched", to: "errors#not_found", via: :all
end
