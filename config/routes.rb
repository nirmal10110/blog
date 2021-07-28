Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "articles#index"
  # get "/articles", to:"articles#index"
  # get "/articles/:id", to:"articles#show"
  resources :articles
  # resources :articles do
  #   collection do
  #     get :search
  #     post :search
  #   end
  # end
  get "/search", to:"articles#index"
  post "/search", to:"articles#search"

  get '/signup', to: "users#new"
  resources :users, except: [:new]

  get '/login', to: "sessions#new"
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


end
