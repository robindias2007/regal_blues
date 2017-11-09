# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    @users = User.order(full_name: :asc).all
  end

  def show
    @user = if params[:query]
              User.search_for(search_params)
            else
              User.find(params[:id])
            end
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end
