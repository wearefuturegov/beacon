Rails.application.routes.draw do
  root 'needs#index'

  resources :contacts, only: [:index, :show, :edit, :update, :new, :create] do
    resources :needs, only: [:new, :create]
    # collection do
    #   get 'call-list'
    # end
    resources :assessments, only: [:new, :create]
    get 'assessments/schedule', to: 'assessments#schedule', as: 'schedule_assessment'
    get 'assessments/log', to: 'assessments#log', as: 'log_assessment'

    get 'triage', to: 'triage#edit', as: 'edit_triage'
    put 'triage', to: 'triage#update', as: 'triage'
  end
  # get '/contacts/:id/needs', to: 'contacts#needs'

  resources :needs, only: [:index, :show, :edit, :update] do
    resources :notes
  end

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  post 'role', to: 'users#set_role', as: 'set_role'
  passwordless_for :users, at: '/', as: :auth

  patch '/needs_multiple' => 'needs#update_multiple'
end
