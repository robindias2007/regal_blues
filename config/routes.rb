# frozen_string_literal: true

Rails.application.routes.default_url_options = {
    host: 'custumise.com'
}

Rails.application.routes.draw do
  devise_for :supports
  root 'home#index'
  mount ActionCable.server => '/cable'
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

      resources :support_chats, only: %i[create index] do
        member do
          resources :conversations, only: %i[create]
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
          get :give_more_options_data, path: 'give-more-options'
          post :give_more_options, path: 'give-more-options'
          patch :toggle_active_gallery_image, path: 'toggle-active-image'
        end
      end

      patch '/orders/:id/galleries/:gallery_id/images/:image_id', to: 'orders#disable_gallery_image'

      resources :support_chats, only: %i[create index] do
        member do
          resources :conversations, only: %i[create]
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
