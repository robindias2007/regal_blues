# frozen_string_literal: true

class V1::Users::AddressesController < V1::Users::BaseController
  def create
    address = current_user.addresses.build(address_params)
    if address.save
      render json: { message: 'Address saved successfully' }, status: 201
    else
      render json: { errors: address.errors.messages }, status: 400
    end
  end

  private

  def address_params
    params.require(:address).permit(:country, :pincode, :street_address, :city, :state, :nickname, :landmark)
  end
end
