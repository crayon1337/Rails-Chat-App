Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  #Import Sidekiq Web UI to monitor jobs
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #Nested Apps/Chats/Messages routes
  resources :applications, param: :token, except: [:new, :edit, :index] do
    resources :chats, param: :token, except: [:new, :edit] do
      resources :messages, param: :token, except: [:new, :edit]
    end
  end

  #Search
  get 'search', to: 'search#doFullMagic'

  #Check Job Status by J_ID
  get 'job/:jid', to: 'home#job' 
end
