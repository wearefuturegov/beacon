Rails.application.routes.draw do
  root 'contacts#call_list'

  resources :contacts, only: [:index, :show, :edit, :update, :new] do
    resources :needs, only: [:new, :create]
    collection do
      get 'call-list'
    end
    get 'triage', to: 'triage#edit', as: 'edit_triage'
    put 'triage', to: 'triage#update', as: 'triage'
  end
  get '/contacts/:id/needs', to: 'contacts#show_needs'

  resources :needs, only: [:index, :show, :edit, :update] do
    resources :notes
  end

  resources :users, only: [:index, :new, :create, :destroy]
  passwordless_for :users, at: '/', as: :auth
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
