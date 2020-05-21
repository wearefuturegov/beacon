Rails.application.routes.draw do
  root 'needs#index'

  resources :contacts, only: [:index, :show, :edit, :update, :new, :create] do
    resources :needs, only: [:new, :create]
    resources :assessments, only: [:new, :create]
    # collection do
    #   get 'call-list'
    # end
    get 'triage', to: 'triage#edit', as: 'edit_triage'
    put 'triage', to: 'triage#update', as: 'triage'
  end
  # get '/contacts/:id/needs', to: 'contacts#needs'

  resources :needs, only: [:index, :show, :edit, :update, :destroy] do
    resources :notes
  end

  resources :notes, only: [:show, :edit, :update]
  resources :mdt, only: [:index]

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  post 'role', to: 'users#set_role', as: 'set_role'
  passwordless_for :users, at: '/', as: :auth

  patch '/needs_bulk_action' => 'needs#bulk_action'
  post '/needs/restore_need' => 'needs#restore_need'
  post '/needs/restore_note' => 'needs#restore_note'
  get '/deleted_items' => 'needs#deleted_items', as: 'deleted_items'
end
