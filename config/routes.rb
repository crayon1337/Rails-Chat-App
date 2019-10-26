Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'applications#index'

  #Nested routes

  resources :applications, param: :token do
    resources :chats do
      resources :messages
    end
  end

end
