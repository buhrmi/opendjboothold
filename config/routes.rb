Rails.application.routes.draw do
  resources :booths
  resources :users
  resources :blobs
  
  namespace :api do
    resources :tracks
  end
  
  resource :session
  
  get '/auth/:provider/callback', to: 'sessions#create'
  
  root "booths#index"
end
