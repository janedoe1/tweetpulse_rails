Tweetpulse::Application.routes.draw do
  
  resources :searches

  resources :tweets

  match '/auth/:provider/callback' => 'authentications#create' 
  resources :authentications

  devise_for :users

  resources :user_terms

  resources :hashtag_terms

  resources :keyword_terms

  resources :terms
  
  resources :twitter_users

  root :to => 'dashboard#index'
  get "/dashboard", :as => "dashboard", :to => "dashboard#index"
  
  get "/dashboard/:search_id/refresh", :as => "refresh_dashboard", :to => "dashboard#refresh_graphs"
  get "/dashboard/refresh", :as => "refresh_dashboard", :to => "dashboard#refresh_graphs"
  
  get "/searches/:search_id/refresh", :as => "refresh_search_results", :to => "searches#refresh_results"
  get "/twitter_users/:twitter_user_id/refresh", :as => "refresh_twitter_user_results", :to => "twitter_users#refresh_results"
  get "/tweets/:tweet_id/refresh", :as => "refresh_tweet_results", :to => "tweets#refresh_results"

  
  get "/auth/twitter", :as => "twitter_auth"
  
  get "/tweets/:tweet_id/tooltip", :as => "tweet_tooltip", :to => "tweets#show_tooltip"
  get "/twitter_users/:twitter_user_id/tooltip", :as => "twitter_user_tooltip", :to => "twitter_users#show_tooltip"
  get "/retweets/:id/tooltip", :as => "retweet_tooltip", :to => "retweets#show_tooltip"
  
  get "/searches/:id/download", :as => "csv_search", :to => "searches#show", :constraints => {:format => /(csv)/}
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
