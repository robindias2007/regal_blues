# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    @users = User.order(full_name: :asc).all
  end
end
