Rails.application.routes.draw do
  resources :contacts, only: [:index, :edit, :update]
  resources :users, only: [:index, :new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contacts#index'
end
