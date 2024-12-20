Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints(ClientDomainConstraint.new) do
    devise_for :client, class_name: 'User',
               only: [:registrations, :sessions],
               controllers: { registrations: 'users/registrations', sessions: 'client/sessions' }, path: 'users'

    scope module: 'client' do
      resources :home, only: :index, path: 'home'
      namespace :users do
        resources :invite_people, only: :index, path: 'invite-people'
      end

      scope module: 'users' do
        resources :me, only: :index do
          collection do
            put :claim_prize
            put :share_feedback
          end

          member do
            get 'claim_prize/:id/select_address', to: 'me#select_address', as: :select_address
          end
        end
        namespace :me do
          get :order_history
          get :winning_history
          get :lottery_history
          get :invitation_history
        end
        resources :address, except: :show, path: 'address'
      end
      resources :orders, only: :index do
        put :cancel
      end
      resources :lotteries, only: [:index, :show]
      resources :shares, only: :index
      resources :shops, only: [:index, :show, :create]
      resources :tickets, only: :create
    end

    root to: 'client/home#index', as: :client_root

  end

  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User',
               only: :sessions,
               controllers: { sessions: 'admin/sessions' }, path: 'users'

    scope module: 'admin' do
      resources :home, only: :index, path: 'home'
      namespace :users do
        resources :clients do
          namespace :orders do
            resources :increase, only: [:new, :create]
            resources :deduct, only: [:new, :create]
            resources :bonus, only: [:new, :create]
            resources :member_level, only: [:new, :create]
          end
        end
      end
      resources :orders, only: :index do
        put :pay
        put :cancel
      end
      resources :categories
      resources :invites, only: :index
      resources :items do
        put :start
        put :pause
        put :end
        put :cancel
      end
      resources :offers
      resources :winners, only: :index do
        put :claim
        put :submit
        put :pay
        put :ship
        put :deliver
        put :publish
        put :remove_publish
      end
      resources :tickets, only: :index do
        put :cancel
      end
      resources :news_tickers
      resources :banners
      resources :member_levels
    end

    root to: 'admin/home#index', as: :admin_root

  end

  resources :addresses, only: :show

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
