Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  #Import Sidekiq Web UI to monitor jobs
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #Nested routes

  resources :applications, param: :token do
    resources :chats, param: :token do
      resources :messages, param: :token
    end
  end

  get 'search', to: 'search#doFullMagic'

end
