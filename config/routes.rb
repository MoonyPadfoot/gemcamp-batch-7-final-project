Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints(ClientDomainConstraint.new) do
    devise_for :client, class_name: 'User', only: :registrations, path_names: { sign_up: 'sign_up' }, path: ''
    devise_for :client, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'client/sessions'
    }, path_names: { sign_in: 'sign_in' }, path: ''

    scope module: 'client' do
      resources :home, only: [:index], path: 'home'
      resources :me, only: [:index], path: 'me'
    end

    root to: 'client/home#index', as: :client_root

  end

  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }, path_names: { sign_in: 'sign_in' }, path: ''

    scope module: 'admin' do
      resources :home, only: [:index], path: 'home'
    end

    root to: 'admin/home#index', as: :admin_root

  end
end
