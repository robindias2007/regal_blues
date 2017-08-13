# frozen_string_literal: true

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
    if identity.nil?
      user = User.create_with_facebook(info)
      handle_fb_persistence_and_issue_jwt_for user
    else
      find_user_and_issue_jwt_for identity
    end
  end

  private

  def auth_params
    params.permit(:login, :password)
  end

  def fb_auth_param
    params.permit(:code)
  end

  def handle_fb_persistence_and_issue_jwt_for(user)
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
end
