Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :clients, class_name: 'User', only: [:sessions], controllers: {
    sessions: 'clients/sessions'
  }

  devise_for :admins, class_name: 'User', only: [:sessions], controllers: {
    sessions: 'admins/sessions'
  }

  get 'clients', to: 'clients#index'

  get 'admins', to: 'admins#index'

  root to: 'home#index'
  # Defines the root path route ("/")
  # root "articles#index"
end
