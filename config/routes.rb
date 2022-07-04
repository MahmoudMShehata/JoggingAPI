Rails.application.routes.draw do
  resources :jogs
  resources :users

  post '/signup',      to: 'users#create'
  get '/login',        to: 'users#login'
end
