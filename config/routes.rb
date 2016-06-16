Rails.application.routes.draw do
  get '/activation/:token', to: 'users#account_activation', as: 'account_activation'
  get '/password_reset/:token', to: 'password_resets#new', as: 'reset_password'
  resource :password_reset, only: [:create]
  resource :sessions, only: [:new, :create, :destroy]
  resource :password_request, only: [:new, :create]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"

  root 'deals#index'

  get "/signup", to: 'users#new'

  resource :users, only: [:create]

  resources :deals, only: [:index, :show] do
    collection do
      get 'search'
      get 'past'
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

  namespace :admin do
    resources :deals do
      member do
        get 'publish'
        get 'unpublish'
      end
    end
  end

  resources :orders do
    resources :charges, only: [:create]
  end
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
