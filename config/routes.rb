Rails.application.routes.draw do
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resource :session
  
  get '/auth/:provider/callback', to: 'sessions#create'
  root "sessions#new"
end
