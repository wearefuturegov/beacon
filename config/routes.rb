# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contacts, only: %i[index show edit update] do
    resources :needs, only: %i[new create]
  end
  get '/contacts/:id/needs', to: 'contacts#show_needs'

  resources :needs, only: %i[index show edit update] do
    resources :notes
  end
  resources :users, only: %i[index new create destroy]
  passwordless_for :users, at: '/', as: :auth
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contacts#index'
end
