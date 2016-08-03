Rails.application.routes.draw do
  get '/activation/:token', to: 'users#account_activation', as: 'account_activation'
  get '/password_reset/:token', to: 'password_resets#new', as: 'reset_password'
  get '/merchant', to: 'merchant/coupons#new'

  post "/subscribe" => "subscriptions#create"

  resource :password_reset, only: [:create]
  resource :sessions, only: [:new, :create, :destroy]
  resource :merchant_sessions, only: [:new, :create, :destroy]
  resource :password_request, only: [:new, :create]

  root 'deals#index'

  get "/signup", to: 'users#new'

  resource :users, only: [:create]

  resources :deals, only: [:index, :show] do
    collection do
      get 'search'
      get 'past'
    end
    member do
      get 'refresh'
    end
    resources :orders, only: [:new, :index, :edit, :update, :destroy, :show]
  end

  resources :merchants, only: [] do
    member do
      get 'deals'
    end
  end

  resources :categories, only: [] do
    member do
      get 'deals'
    end
  end

  get 'admin' => 'admin#index'

  namespace :api, defaults: { format: :json } do
    get '/orders/:token', to: 'orders#show'
  end

  namespace :merchant do
    resources :coupons, only: [:new] do
      collection do
        post 'redeem'
      end
    end
    resources :deals, only: [:index, :show]
  end

  namespace :admin do
    resources :deals do
      member do
        put 'publish'
        put 'unpublish'
      end
    end
    resources :reports, only: [] do
      collection do
        get 'merchants'
      end
    end
  end

  resources :orders do
    resources :charges, only: [:create]
  end

end
