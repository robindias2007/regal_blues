# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  constraints subdomain: 'api.user' do
    scope module: :v1, constraints: RouteConstraints.new(version: 1, default: true), defaults: { format: :json } do
      scope module: :users do
        post 'sign-up', to: 'registrations#create'
        get 'confirm/:token', to: 'registrations#confirm'
        post 'resend-confirmation-token', to: 'registrations#resend_confirmation'
        post 'login', to: 'sessions#create'
        post 'send-reset-password-instructions', to: 'sessions#send_reset_password_instructions'
        get '/reset-password/:token', to: 'sessions#reset_password'
      end
    end
  end
end
