Rails.application.routes.draw do
  get 'alerts/index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :cams


  root to: "cams#index"
  # get 'monitor/ON' => 'monitor#monitor_on'
  # get 'monitor/OFF' => 'monitor#monitor_off'
  # get '/monitor/ON' => 'monitor#monitor_on', as: :monitor_on
  get '/monitor_on/:id' => 'monitor#monitor_on', as: :monitor_on
  get '/monitor_off/:id' => 'monitor#monitor_off', as: :monitor_off
  
  get '/status_check/:id' => 'monitor#status_check', as: :status_check
  # get '/monitorfire/:id/' => 'monitor#firebase'
  get 'monitorfire/:id' => 'monitor#show'

  get 'textfire_on/:id' => 'send_text#text_alert_on' #, as :text_alert
  get 'textfire_off/:id' => 'send_text#text_alert_off' #, as :text_alert

  # root :to => "pages#show", :id => 3
  # get 'cam_alert/OFF' => 'alerts#monitor_off'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
