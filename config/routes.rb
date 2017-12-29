# frozen_string_literal: true

Rails.application.routes.default_url_options = {
    host: 'custumise.com'
}

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :supports
  scope module: :support do
    get '/', to: 'home#index', as: :support_root
    authenticated :support do
      get '/search/users', to: 'search#users', as: :support_user_search
      get '/search/designers', to: 'search#designers', as: :support_designer_search
      get '/search/orders', to: 'search#orders', as: :support_order_search
      get 'search/user-suggestions', to: 'search#users_suggestions'
      get 'search/designer-suggestions', to: 'search#designers_suggestions'
      resources :users, only: %i[index show], as: :support_users
      resources :designers, only: %i[index show], as: :support_designers
      resources :requests, only: %i[index show], as: :support_requests do
        patch :approve
        patch :reject
      end
      resources :orders, only: %i[show], as: :support_orders  
    end
  end

  scope module: :v1, path: 'supports', constraints: RouteConstraints.new(version: 1, default: true),
  defaults: { format: :json } do
    scope module: :supports do
      post 'login', to: 'sessions#create'

      resources :conversations, only: %i[index create show destroy] do
        collection do
          post :chat_type
          post :fetch_conversation
        end
        member do
          resources :messages, only: %i[index create]
        end
      end
    end
  end

  get '/quoation/:id' => 'support/requests#show_request_quo', as: :quoation
  get '/chat_details' => 'support/chats#chat_details'
  get '/chat/:id' => 'support/requests#chat', as: :chat


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
      get 'resend-otp', to: 'registrations#resend_otp'
      post 'verify-otp', to: 'registrations#verify_otp'
      get 'me', to: 'registrations#show'
      get 'me/update', to: 'registrations#update'
      delete '/me/delete', to: 'registrations#destroy'

      # Authentication
      post 'login', to: 'sessions#create'
      match 'auth/facebook', to: 'sessions#facebook', via: %i[get post]
      match 'auth/google', to: 'sessions#google', via: %i[get post]

      # Home Controller
      get 'home/mobile', to: 'home#mobile'

      # Sub Categories
      resources :sub_categories, only: :index, path: 'sub-categories'

      # Designers
      resources :designers, only: %i[index show]

      # Requests
      resources :requests, only: %i[index create show] do
        collection do
          get :init_data, path: 'init-data'
          get 'designers/:category_id' => :designers
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
      get 'search/:q', to: 'search#index'
      post 'external-search/create', to: 'external_searches#create'
      get 'external-search/modal-suggestions', to: 'external_searches#search_suggestions'
      get 'external-search/top-suggestions', to: 'external_searches#top_query_suggestions'

      resources :orders, only: %i[index show create] do
        member do
          get :pay
          get :measurement_tags
          post :update_measurements
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
          resources :messages, only: %i[index create]
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
      get 'reset-password/:token', to: 'registrations#reset_password'
      post 'update-password', to: 'registrations#update_password'
      post 'update-mobile-number', to: 'registrations#update_mobile_number'
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
          resources :messages, only: %i[index create]
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
