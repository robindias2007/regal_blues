# frozen_string_literal: true

require 'google/apis/plus_v1'
require 'signet/oauth_2/client'

class V1::Users::SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_for_auth(auth_params[:login])
    if user.authenticate(auth_params[:password])
      issue_jwt(user)
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  def facebook
    info = Omniauth::FacebookAuth.authenticate(fb_auth_param[:code])
    identity = UserIdentity.find_by(uid: info[:user_info]['id'], provider: 'facebook')
    omni_authenticate(identity) { User.create_with_facebook(info) }
  end

  def google
    info = Omniauth::GoogleAuth.authenticate(google_auth_param[:code]).get_person('me')
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

  def google_auth_param
    params.permit(:code)
  end

  def handle_persistence_and_issue_jwt_for(user)
    if user.persisted?
      issue_jwt(user)
    else
      render json: { errors: user.errors.messages }, status: 400
    end
  end

  def find_user_and_issue_jwt_for(identity)
    user = identity.user
    issue_jwt(user)
  end

  def omni_authenticate(identity)
    if identity.nil?
      user = yield
      handle_persistence_and_issue_jwt_for user
    else
      find_user_and_issue_jwt_for identity
    end
  end

  def issue_jwt(user)
    jwt = Auth.issue(user: user.id)
    render json: { jwt: jwt }, status: 200
  end
end
