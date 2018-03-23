# frozen_string_literal: true

Rails.application.routes.default_url_options = {
    host: ENV['APPLICATION_BASE_URL']
}

Rails.application.routes.draw do
  resources :config_variables
  

  resources :picks
  mount ActionCable.server => '/cable'

  devise_for :supports
  scope module: :support do
    get '/', to: 'home#index', as: :support_root
    authenticated :support do
      get '/search/users', to: 'search#users', as: :support_user_search
      get '/search/designers', to: 'search#designers', as: :support_designer_search
      get '/search/orders', to: 'search#orders', as: :support_order_search
      get '/search/requests', to: 'search#requests', as: :support_request_search
      get 'search/user-suggestions', to: 'search#users_suggestions'
      get 'search/designer-suggestions', to: 'search#designers_suggestions'
      
      # Generating Reports Based on the Queries 
      get 'supports/reports' => 'reports#list_reports', as: :support_reports 
      get 'supports/requests_24' => 'reports#requests_24'
      get 'supports/requests_48' => 'reports#requests_48'
      get 'supports/awating_meas' => 'reports#awating_meas'
      get 'supports/no_offer_requests_24' => 'reports#no_offer_requests_24'
      get 'supports/no_offer_requests_48' => 'reports#no_offer_requests_48'
      get 'supports/user_nooffer_24' => 'reports#user_nooffer_24'
      get 'supports/user_nooffer_48' => 'reports#user_nooffer_48'
      get 'supports/hot_users' => 'reports#hot_users'
      get 'supports/warm_users' => 'reports#warm_users'
      get 'supports/cold_users' => 'reports#cold_users'
      get 'supports/offer_requests' => 'reports#offer_requests'
      get 'supports/requests_nooffers_10000' => 'reports#requests_nooffers_10000'
      get 'supports/requests_nooffers_10_15' => 'reports#requests_nooffers_10_15'
      get 'supports/requests_nooffers_15000' => 'reports#requests_nooffers_15000'
      

      resources :users, only: %i[index show update], as: :support_users
      resources :designers, only: %i[index show], as: :support_designers
      resources :requests, only: %i[index show update create], as: :support_requests do
        patch :approve
        patch :reject
      end
      get '/send_messages' => 'messages#index'
      post '/send_messages' => 'messages#create'
      post 'supports/conversations' => 'users#create', as: :support_conversation
      resources :orders, only: %i[index], as: :support_orders  
      resources :orders, only: %i[show], as: :support_show_orders  
      resources :offers, only: %i[index show destroy], as: :support_offers  
      post 'offer_quotation/:offer_id' => 'offers#create_quotation', as: :support_offer_quotation
      patch 'offer_quotation/:offer_id' => 'offers#update_quotation', as: :support_offer_update 

      resources :chats, only: %[index], as: :support_chats
    end
  end

  scope module: :v1, path: 'supports', constraints: RouteConstraints.new(version: 1, default: true),
  defaults: { format: :json } do
    scope module: :supports do
      post 'login', to: 'sessions#create'
      post 'update_devise_token', to: 'registrations#update_devise_token'
      #notifications
      post 'notifications', to: 'messages#notifications'

      resources :conversations, only: %i[index create show destroy] do
        collection do
          post :chat_type
          post :fetch_conversation
          get :init_data
        end
        member do
          resources :messages, only: %i[index create update]
        end
      end
    end
  end

  get '/quoation/:id' => 'support/requests#show_request_quo', as: :quoation
  get '/product/:id' => 'support/designers#show_product_details', as: :product  

  get '/chat/:id' => 'support/requests#chat', as: :chat
  post '/chat/:id' => 'support/requests#chat_post', as: :chat_post
  post '/request_images' => 'support/requests#request_images'

  post '/gallery_images' => 'support/offers#gallery_images'

  get '/designers/measurements' => 'v1/designers/offer_quotations#measurement_tags'

  get '/push_token' => 'support/push_tokens#index'
  post '/push_token' => 'support/push_tokens#create', as: :push_create

  get '/users/create_request/:id' => 'support/users#create_request', as: :support_create_request  

  resources :measurement_tags
  
  resources :events, only: %i[index create]


  # constraints(subdomain: 'support') do
  #   devise_for :supports, path: ''
  #   scope module: :support do
  #     get '/', to: 'home#index', as: :support_root
  #     authenticated :support do
  #       get '/search/users', to: 'search#users', as: :support_user_search
  #       get '/search/designers', to: 'search#designers', as: :support_designer_search
  #       get '/search/orders', to: 'search#orders', as: :support_order_search
  #       get 'search/user-suggestions', to: 'search#users_suggestions'
  #       get 'search/designer-suggestions', to: 'search#designers_suggestions'
  #       resources :users, only: %i[index show], as: :support_users
  #       resources :designers, only: %i[index show], as: :support_designers
  #       resources :requests, only: %i[index show], as: :support_requests do
  #         patch :approve
  #         patch :reject
  #       end
  #       resources :orders, only: %i[index show], as: :support_orders
  #     end
  #   end
  # end

  root 'home#index'

  scope module: :v1, path: 'users', constraints: RouteConstraints.new(version: 1, default: true),
    defaults: { format: :json } do
    scope module: :users do
      # Registration
      post 'sign-up', to: 'registrations#create'
      get 'confirm/:token', to: 'registrations#confirm'
      post 'resend-confirmation-email', to: 'registrations#resend_confirmation'
      post 'send-reset-password-instructions', to: 'registrations#send_reset_password_instructions'
      get 'reset-password/:token', to: 'registrations#reset_password'
      get 'people', to: 'registrations#people'
      post 'update-password', to: 'registrations#update_password'
      post 'update-mobile-number', to: 'registrations#update_mobile_number'
      post 'update_devise_token', to: 'registrations#update_devise_token'
      post 'update_membership', to: 'registrations#update_membership'
      get 'resend-otp', to: 'registrations#resend_otp'
      post 'verify-otp', to: 'registrations#verify_otp'
      get 'me', to: 'registrations#show'
      post 'me/update', to: 'registrations#update'
      delete '/me/delete', to: 'registrations#destroy'

      #notifications
      post 'notifications', to: 'messages#notifications'
      # Authentication
      post 'login', to: 'sessions#create'
      match 'auth/facebook', to: 'sessions#facebook', via: %i[get post]
      match 'auth/google', to: 'sessions#google', via: %i[get post]

      # Home Controller
      get 'home/mobile', to: 'home#mobile'
      get 'home/mobile_v2', to: 'home#mobile_v2'

      # Sub Categories
      resources :sub_categories, only: :index, path: 'sub-categories'

      # Designers
      resources :designers, only: %i[index show]

      # Requests
      resources :requests, only: %i[index create show] do
        collection do
          get :init_data, path: 'init-data'
          get 'designers/:category_id' => :designers
          post  :create_v2
          post  :create_request_images_v2
        end
        member do
          resources :offers, only: %i[index show]
        end
      end

      # Offers
      resources :offers, only: %i[index show]

      # Shipping Addresses
      resources :addresses, only: %i[index create]

      resources :products, only: %i[index show]

      get 'explore/mobile', to: 'explore#mobile'
      get 'explore/mobile_v2', to: 'explore#mobile_v2'
      get 'search/:q', to: 'search#index'
      post 'external-search/create', to: 'external_searches#create'
      get 'external-search/modal-suggestions', to: 'external_searches#search_suggestions'
      get 'external-search/top-suggestions', to: 'external_searches#top_query_suggestions'

      resources :orders, only: %i[index show create] do
        member do
          get :pay
          get :measurement_tags
          post :update_measurements
          post :update_measurements_v2
          post :submit_options
          get :cancel_order
        end
      end

      resources :order_payments, only: %i[create update]

      # resources :support_chats, only: %i[create index] do
      #   member do
      #     resources :conversations, only: %i[create]
      #   end
      # end

      resources :conversations, only: %i[index create show destroy] do
        collection do
          get :chat_type
          post :fetch_conversation
          #get :chat_type_request
        end
        member do
          resources :messages, only: %i[index create update]
        end
      end

      resources :offer_quotation_chats, only: %i[create] do
        member do
          resources :conversations, only: %i[create]
        end
      end

      resources :user_favorite_products, only: :create, path: 'add-to-wishlist'
      resources :user_favorite_designers, only: :create, path: 'add-to-favorites'
    end
  end

  scope module: :v1, path: 'designers', constraints: RouteConstraints.new(version: 1, default: true),
    defaults: { format: :json } do
    scope module: :designers do
      # Registration
      post 'sign-up', to: 'registrations#create'
      get 'confirm/:token', to: 'registrations#confirm'
      post 'resend-confirmation-email', to: 'registrations#resend_confirmation'
      post 'send-reset-password-instructions', to: 'registrations#send_reset_password_instructions'
      get 'reset-password/:token', to: 'registrations#reset_password', :constraints => { :token => /.+@.+\..*/ }
      post 'update-password', to: 'registrations#update_password'
      post 'update-mobile-number', to: 'registrations#update_mobile_number'
      post 'update_devise_token', to: 'registrations#update_devise_token'
      get 'resend-otp', to: 'registrations#resend_otp'
      post 'verify-otp', to: 'registrations#verify_otp'
      post 'update-store-info', to: 'registrations#update_store_info'
      post 'update-finance-info', to: 'registrations#update_finance_info'
      get 'list-categories', to: 'registrations#list_categories'
      post 'associate-categories', to: 'registrations#associate_categories'
      get 'bank-details/:ifsc_code', to: 'registrations#bank_details'

      # Profile Update
      get 'me', to: 'registrations#profile'
      patch 'me/toggle-active', to: 'registrations#toggle_active'
      post 'me/update', to: 'registrations#update_profile'
      post 'me/update-profile-password', to: 'registrations#update_profile_password'
      get 'me/send-otp', to: 'registrations#send_update_otp'
      get 'me/resend-otp', to: 'registrations#resend_update_otp'
      post 'me/verify-updated-number', to: 'registrations#verify_updated_number'

      # Authentication
      post 'login', to: 'sessions#create'

      # Products
      resources :products, only: %i[index create show destroy] do
        patch :toggle_active, on: :member
        get :search, on: :collection
      end

      #notifications
      post 'notifications', to: 'messages#notifications'

      # Designer Categories
      resources :designer_categorizations, only: :index, path: 'designer-categories'

      # Designer Requests
      resources :requests, only: %i[index show destroy] do
        patch :toggle_not_interested, on: :member
        patch :mark_involved, on: :member
      end

      # Offers
      resources :offers, only: %i[index create show] do
        resources :offer_quotations, only: %i[index show], path: 'quoations', on: :member
      end



      resources :orders, only: %i[index show] do
        member do
          patch :confirm
          get :fabric_unavailable_data, path: 'fabric-unavailable'
          put :fabric_unavailable, path: 'fabric-unavailable'
          patch :fabric_unavailable, path: 'fabric-unavailable'
          get :give_more_options_data, path: 'give-more-options'
          post :give_more_options, path: 'give-more-options'
          patch :toggle_active_gallery_image, path: 'toggle-active-image'
        end
      end

      patch '/orders/:id/galleries/:gallery_id/images/:image_id', to: 'orders#disable_gallery_image'

      # resources :support_chats, only: %i[create index] do
      #   member do
      #     resources :conversations, only: %i[create]
      #   end
      # end

      resources :conversations, only: %i[index create show destroy] do
        collection do
          get :chat_type
          post :fetch_conversation
          #get :chat_type_request
        end
        member do
          resources :messages, only: %i[index create update]
        end
      end

      resources :request_chats, only: %i[create show] do
        member do
          resources :conversations, only: %i[create]
        end
      end

      resources :offer_quotation_chats, only: %i[create] do
        member do
          resources :conversations, only: %i[create]
        end
      end
    end
  end
end
