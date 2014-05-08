TaskManager::Application.routes.draw do
  root 'users#next_seven_days'
  match '/home',  to: 'static_pages#home',  via: 'get'
  match '/help',  to: 'static_pages#help',  via: 'get'
  match '/about',  to: 'static_pages#about',  via: 'get'

  get "contacts/new"
  get "contacts/create"
  get "tags/new"
  get "tags/create"
  get "tags/show"
  #twilio route
  #match '/twilio/happy', to: 'twilio#voice', via: 'post'

  get "days/show"
  get "days/next_seven_days"
  #last seven days route?

  #users resources
  resources :users do
    get 'next_seven_days', on: :member
    get 'user_weeks', on: :member
    patch 'number', on: :member
    patch 'update_settings', on: :member
    patch 'edit_avatar', on: :member
    #get 'search_tags', on: :member
    # get 'sms_empty', on: :member
  end
  
  match '/signup', to: 'users#new', via: 'get'
  
  #sessions resources
  resources :sessions, only: [:new, :destroy, :create]
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'


  # for e-mail contact action
  match '/contacts', to: 'contacts#new',  via: 'get'
  resources "contacts", only: [:new, :create]

  match '/signup', to: 'user#new', via: 'get'
  get "users/new"


  resources :weeks

  resources :tags

  # days and tasks resource
  resources :days do
    resources :tasks do
      get 'gcal', on: :member
      patch 'email', on: :member
      patch 'important', on: :member
      patch 'complete', on: :member
      patch 'time', on: :member
      patch 'edit_text', on: :member
      patch 'remove_overdue', on: :member
      post 'update_ordering', on: :collection
    end
  end

  # match '/happy', to: 'users#happy', via: 'post'
  post 'twilio/voice' => 'twilio#voice'
  post 'twilio/message' => 'twilio#message'

  resource :password_resets


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'weeks#index'

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
