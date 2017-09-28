# frozen_string_literal: true

Rails.application.routes.default_url_options = {
    host: 'custumise.com'
}

Rails.application.routes.draw do
  root 'home#index'
  # namespace 'api.user' do
  scope module: :v1, path: 'users', constraints: RouteConstraints.new(version: 1, default: true),
    defaults: { format: :json } do
    scope module: :users do
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

      # Authentication
      post 'login', to: 'sessions#create'
      match 'auth/facebook', to: 'sessions#facebook', via: %i[get post]
      match 'auth/google', to: 'sessions#google', via: %i[get post]

      # Home Controller
      get 'home/mobile', to: 'home#mobile'

      # Sub Categories
      resources :sub_categories, only: :index, path: 'sub-categories'

      # Designers
      resources :designers, only: :index

      # Requests
      resources :requests, only: %i[index create show] do
        collection do
          get :init_data, path: 'init-data'
          get 'designers/:category_id' => :designers
        end
      end

      # Offers
      resources :offers, only: %i[index show]

      # Shipping Addresses
      resources :addresses, only: %i[index create]

      resources :products, only: %i[index show]

      get 'explore/mobile', to: 'explore#mobile'
      get 'search/:q', to: 'search#index'
    end
  end
  # end

  # constraints subdomain: 'api.designer' do
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

      # Authentication
      post 'login', to: 'sessions#create'

      # Products
      resources :products, only: %i[index create show] do
        patch :toggle_active, on: :member
      end

      # Designer Categories
      resources :designer_categorizations, only: :index, path: 'designer-categories'

      # Designer Requests
      resources :requests, only: %i[index show] do
        patch :toggle_not_interested, on: :member
      end

      # Offers
      resources :offers, only: %i[index create show]
    end
    # end
  end
end
