Rails.application.routes.draw do
  resources :welcomes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'welcomes#index'
end
