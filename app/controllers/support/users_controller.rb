# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    @users = User.order(full_name: :asc).all
  end

  def show
    @user = User.find(params[:id])
  end
end
