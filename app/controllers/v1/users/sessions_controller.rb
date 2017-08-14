# frozen_string_literal: true

require 'google/apis/plus_v1'
require 'signet/oauth_2/client'

class V1::Users::SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_for_auth(auth_params[:login])
    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { jwt: jwt }, status: 200
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  def facebook
    info = Omniauth::Facebook.authenticate(fb_auth_param[:code])
    identity = UserIdentity.find_by(uid: info[:user_info]['id'], provider: 'facebook')
    omni_authenticate(identity) { User.create_with_facebook(info) }
  end

  def google
    info = user_info.get_person('me')
    identity = UserIdentity.find_by(uid: info.id, provider: 'google')
    omni_authenticate(identity) { User.create_with_google(info) }
  end

  private

  def auth_params
    params.permit(:login, :password)
  end

  def fb_auth_param
    params.permit(:code)
  end

  def handle_persistence_and_issue_jwt_for(user)
    if user.persisted?
      jwt = Auth.issue(user: user.id)
      render json: { jwt: jwt }, status: 200
    else
      errors = user.errors.messages
      Rails.logger.debug errors
      render json: { errors: errors }, status: 400
    end
  end

  def find_user_and_issue_jwt_for(identity)
    user = identity.user
    jwt = Auth.issue(user: user.id)
    render json: { jwt: jwt }, status: 200
  end

  def user_info
    Google::Apis::PlusV1::PlusService.new.tap do |userinfo|
      userinfo.key = Rails.application.secrets.goole_api_key
      userinfo.authorization = auth_client
    end
  end

  def auth_client
    Signet::OAuth2::Client.new(
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      scope: 'email profile', redirect_uri: 'http://localhost:4200/oauth2callback',
      access_type: 'offline'
    ).tap do |client|
      client.code = params['code']
      client.fetch_access_token!
    end
  end

  def omni_authenticate(identity)
    if identity.nil?
      user = yield
      handle_persistence_and_issue_jwt_for user
    else
      find_user_and_issue_jwt_for identity
    end
  end
end
