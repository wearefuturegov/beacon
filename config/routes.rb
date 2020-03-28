Rails.application.routes.draw do
  resources :contacts
  resources :users, only: [:index, :new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contacts#index'

  get '/auth/auth0/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get '/logout' => 'sessions#destroy', :as => :destroy_user_session
end
