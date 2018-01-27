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

  def create
    conversation = current_support.conversations.find_or_create_by(receiver_id: params[:receiver_id], receiver_type: params[:receiver_type])
    if conversation
      redirect_to support_users_path
    else
      redirect_to support_users_path
    end
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end
