Dashboard::Application.routes.draw do
  resources :stages


  get '/dashboard' => 'home#dashboard'
  root to: 'home#index'
  
  
  devise_scope :user do
    get '/api/current_user' => 'users/sessions#show_current_user', as: 'show_current_user'
    post '/api/check/is_user' => 'users/users#is_user', as: 'is_user'
  end

  devise_for :users,
    :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks"
    }

  namespace :api do
    resources :tests
  end

  resources :users
  resources :projects do 
      get 'display', :on => :member
      get 'first_stage', :on => :member
  end
  resources :tests
  resources :records do
    collection do
      post 'my_create'
    end
    post 'my_edit', :on => :member
    get 'move_to_next_stage', :on => :member
    get 'move_to_stage', :on => :member
    get 'reject', :on => :member
    get 'reschedule_in_sec', :on => :member
    get 'wait_for_sec', :on => :member
  end
  resources :tasks do
    collection do
      get 'urgent_and_today'
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
