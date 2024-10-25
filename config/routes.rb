Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints(ClientDomainConstraint.new) do
    devise_for :client, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'client/sessions'
    }, path_names: { sign_in: 'sign_in' }, path: ''

    namespace :admin do
      resources :home, only: [:index]
    end
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }, path_names: { sign_in: 'sign_in' }, path: ''

    namespace :client do
      resources :home, only: [:index]
    end
  end

  authenticated :user, ->(role) { role.client? } do
    root to: 'client/home#index', as: :client_root
  end

  authenticated :user, ->(role) { role.admin? } do
    root to: 'admin/home#index', as: :admin_root
  end
end
