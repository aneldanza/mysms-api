require "devise"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
  # 

  get '/health', to: 'health#index'


  # Defines the root path route ("/")
  # root "posts#index"
  #
  resources :messages, only: [:index, :create]

  post "/twilio/status", to: "twilio#status"
  get "me", to: "users#me"

  devise_for :users,
             controllers: {
               registrations: "users/registrations",
               sessions: "users/sessions",
             }

  mount ActionCable.server => '/cable'

end
