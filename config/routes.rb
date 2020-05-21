Rails.application.routes.draw do
  root 'needs#index'

  resources :contacts, only: [:index, :show, :edit, :update, :new, :create] do
    resources :needs, only: [:new, :create]
    resources :assessments, only: [:new, :create, :edit, :update]
    # collection do
    #   get 'call-list'
    # end
    get 'triage', to: 'triage#edit', as: 'edit_triage'
    put 'triage', to: 'triage#update', as: 'triage'
  end
  # get '/contacts/:id/needs', to: 'contacts#needs'

  resources :assessments, only: [:index, :show, :destroy, :edit, :update] do
    resources :notes

    get 'fail', on: :member
    put 'update_failure', on: :member

    get 'assign', on: :member
    put 'update_assignment', on: :member

    get 'complete', on: :member
    put 'update_completion', on: :member
  end

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
  get '/deleted_needs' => 'needs#deleted_needs', as: 'deleted_needs'
  get '/deleted_notes' => 'needs#deleted_notes', as: 'deleted_notes'
end
