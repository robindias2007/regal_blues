# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  constraints subdomain: 'api.user' do
    scope module: :v1, defaults: { format: :json } do
      scope module: :user do
      end
    end
  end
end
