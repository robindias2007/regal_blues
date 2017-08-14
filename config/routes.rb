# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  constraints subdomain: 'api.user' do
    scope module: :v1, constraints: RouteConstraints.new(version: 1, default: true), defaults: { format: :json } do
      scope module: :users do
        # Registration
        post 'sign-up', to: 'registrations#create'
        get 'confirm/:token', to: 'registrations#confirm'
        post 'resend-confirmation-token', to: 'registrations#resend_confirmation'
        post 'send-reset-password-instructions', to: 'registrations#send_reset_password_instructions'
        get 'reset-password/:token', to: 'registrations#reset_password'
        post 'update-password', to: 'registrations#update_password'
        get 'resend-otp', to: 'registrations#resend_otp'
        post 'verify-otp', to: 'registrations#verify_otp'

        # Authentication
        post 'login', to: 'sessions#create'
        match 'auth/facebook', to: 'sessions#facebook', via: %i[get post]
        match 'auth/google', to: 'sessions#google', via: %i[get post]
      end
    end
  end

  constraints subdomain: 'api.designer' do
    scope module: :v1, constraints: RouteConstraints.new(version: 1, default: true), defaults: { format: :json } do
      scope module: :designers do
        # Registration
        post 'sign-up', to: 'registrations#create'
        get 'confirm/:token', to: 'registrations#confirm'
        post 'resend-confirmation-token', to: 'registrations#resend_confirmation'
        post 'send-reset-password-instructions', to: 'registrations#send_reset_password_instructions'
        get 'reset-password/:token', to: 'registrations#reset_password'
        post 'update-password', to: 'registrations#update_password'
        get 'resend-otp', to: 'registrations#resend_otp'
        post 'verify-otp', to: 'registrations#verify_otp'

        # Authentication
        post 'login', to: 'sessions#create'
      end
    end
  end
end
