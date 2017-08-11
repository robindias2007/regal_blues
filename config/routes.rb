# frozen_string_literal: true

require 'route_constraints'

Rails.application.routes.draw do
  root 'home#index'
  constraints subdomain: 'api.user' do
    scope module: :v1, constraints: RouteConstraints.new(version: 1, default: true), defaults: { format: :json } do
      scope module: :users do
        post 'sign-up', to: 'registrations#create'
        get 'users/confirm', to: 'registrations#confirm'
      end
    end
  end
end
