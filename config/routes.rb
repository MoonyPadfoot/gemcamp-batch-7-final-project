Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints(ClientDomainConstraint.new) do
    devise_for :client, class_name: 'User',
               only: [:registrations, :sessions],
               controllers: { registrations: 'users/registrations', sessions: 'client/users/sessions' }, path: 'users'

    scope module: 'client' do
      resources :home, only: [:index], path: 'home'
      resources :lottery, only: [:index, :show], path: 'lottery'
      namespace :users do
        resources :invite_people, only: [:index], path: 'invite-people'
      end

      scope module: 'users' do
        resources :me, only: [:index], path: 'me'
        resources :address, except: :show, path: 'address'
      end
    end

    resources :ticket, only: [:create], path: 'ticket'

    root to: 'client/home#index', as: :client_root

  end

  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User',
               only: [:sessions],
               controllers: { sessions: 'admin/sessions' }, path: 'users'

    scope module: 'admin' do
      resources :home, only: [:index], path: 'home'
      resources :item, path: 'item' do
        put :start
        put :pause
        put :end
        put :cancel
      end
      resources :category, path: 'category'
    end

    resources :ticket, only: [:index], path: 'ticket' do
      put :cancel
    end

    root to: 'admin/home#index', as: :admin_root

  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
