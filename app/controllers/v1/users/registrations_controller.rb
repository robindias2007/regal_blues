# frozen_string_literal: true

class V1::Users::RegistrationsController < V1::Users::BaseController
  include Registerable

  def show
    render json: current_user, serializer: V1::Users::ProfileSerializer
  end

  def update
    if current_user.update(update_params)
      render json: { message: 'User profile has been updated' }
    else
      render json: { errors: current_user.errors }
    end
  end

  def destroy
    current_user.destroy
    render json: { message: 'User has been deleted' }, status: 200
  end

  private

  def update_params
    params.require(:user).permit(:full_name, :gender, :avatar, :bio)
  end
end
