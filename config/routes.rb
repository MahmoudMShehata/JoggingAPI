Rails.application.routes.draw do
  resources :jogs
  resources :users

  post '/signup',      to: 'users#create'
  get '/login',        to: 'users#login'
  get '/weeklyreport', to: 'jogs#weekly_report'
  get '/filterjogs',   to: 'jogs#filter_from_to'
end
