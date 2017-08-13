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
    auth = request.env['omniauth.auth']
    identity = UserIdentity.find_with_omniauth(auth)
    identity = UserIdentity.create_with_omniauth(auth) if identity.nil?
    if logged_in?
      handle_logged_in_user(identity)
    else
      associate_identity_with_user(identity)
    end
  end

  private

  def auth_params
    params.permit(:login, :password)
  end

  def handle_logged_in_user(identity)
    if identity.user == current_user
      render json: { message: 'Account already linked' }, status: 200
    else
      identity.user = current_user
      identity.save
      render json: { message: 'Account successfully linked' }, status: 201
    end
  end

  def associate_identity_with_user(identity)
    if identity.user.present?
      self.current_user = identity.user
      render json: { message: 'Signed in!' }, status: 200
    else
      render json: { errors: 'Please finish registering' }, status: 400
    end
  end
end
