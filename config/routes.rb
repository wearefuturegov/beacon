Rails.application.routes.draw do
  resources :contacts, only: [:index, :show, :edit, :update] do
    resources :needs, only: [:new, :create]
  end
  get '/contacts/:id/needs', to: 'contacts#show_needs'

  resources :needs, only: [:index, :show, :edit, :update] do
    resources :notes
  end
  resources :my_needs, only: [:index], path: 'my-needs'
  resources :users, only: [:index, :new, :create, :destroy]
  passwordless_for :users, at: '/', as: :auth
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contacts#index'
end
