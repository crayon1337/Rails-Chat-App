# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  # Import Sidekiq Web UI to monitor jobs
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Nested Apps/Chats/Messages routes
  resources :applications, param: :token, except: %i[new edit index] do
    resources :chats, param: :token, except: %i[new edit] do
      get 'search', to: 'search#dofullmagic'
      resources :messages, param: :token, except: %i[new edit]
    end
  end

  # Check Job Status by J_ID
  get 'job/:jid', to: 'home#job'
end
