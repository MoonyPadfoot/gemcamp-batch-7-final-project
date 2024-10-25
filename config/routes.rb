Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints(ClientDomainConstraint.new) do
    namespace :admin do
      resources :home, only: [:index]
    end
  end

  constraints(AdminDomainConstraint.new) do
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
