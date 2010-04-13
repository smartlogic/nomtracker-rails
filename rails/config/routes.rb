ActionController::Routing::Routes.draw do |map|
  map.root :controller => "start"

  map.start '/start',   :controller => 'start',    :action => 'index'
  map.balances '/balances', :controller => 'users', :action => 'balances'
  map.emails "/emails", :controller => "users", :action => "emails"
  map.transactions_with_user "/transactions_with_user/:id", :controller => "users", :action => "transactions_with_user"
  map.resources :transactions

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login  '/login',  :controller => 'sessions', :action => 'new'

  map.register '/register',                  :controller => 'users', :action => 'create'
  map.signup   '/signup',                    :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  
  map.about '/about',                        :controller => 'about', :action => 'index'

  map.resources :users, :only => [:new, :create, :index], :collection => [:find, :authenticate_user]

  map.resource :session

  map.account '/account', :controller => 'account', :action => 'index'
  map.resource :account, :controller => 'account', :member => {'add_email' => :post, 'activate_email' => :get, :remove_email => :post, :update_preferences => :post}

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
