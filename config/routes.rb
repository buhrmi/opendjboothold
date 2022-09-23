Rails.application.routes.draw do
  resources :booths
  resources :users
  resources :blobs
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resource :session
  
  get '/auth/:provider/callback', to: 'sessions#create'
  root "booths#index"
end
