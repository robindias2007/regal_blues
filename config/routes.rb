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
      end
    end
  end
end
