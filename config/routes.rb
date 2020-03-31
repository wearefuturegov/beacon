Rails.application.routes.draw do
  resources :contacts, only: [:index, :show, :edit, :update] do
    resources :tasks, only: [:create]
    resources :needs, only: [:new, :create]
  end
  get '/contacts/:id/tasks', to: 'contacts#show_tasks'

  resources :tasks, only: [:index, :show, :edit, :update]
  resources :my_tasks, only: [:index], path: 'my-tasks'
  resources :users, only: [:index, :new, :create, :destroy]
  passwordless_for :users, at: '/', as: :auth
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contacts#index'
end
