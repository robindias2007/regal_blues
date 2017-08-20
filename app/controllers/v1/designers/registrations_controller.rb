# frozen_string_literal: true

class V1::Designers::RegistrationsController < V1::Designers::BaseController
  include Registerable

  def update_store_info
    store_info = current_designer.build_designer_store_info(store_info_params)
    if store_info.save
      render json: { message: 'Store info successfully updated' }, status: 201
    else
      render json: { errors: 'Something went wrong' }, status: 400
    end
  end

  def update_finance_info
    finance_info = current_designer.build_designer_finance_info(finance_info_params)
    if finance_info.save
      render json: { message: 'Store info successfully updated' }, status: 201
    else
      render json: { errors: 'Something went wrong' }, status: 400
    end
  end

  private

  def store_info_params
    params.require(:data).permit(:display_name, :registered_name, :pincode, :country, :state, :city, :address_line_1,
      :address_line_2, :contact_number, :min_order_price, :processing_time)
  end

  def finance_info_params
    params.require(:data).permit(:bank_name, :bank_branch, :ifsc_code, :account_number, :personal_pan_number,
      :business_pan_number, :tin_number, :gstin_number, :blank_cheque_proof, :personal_pan_number_proof,
      :business_pan_number_proof, :tin_number_proof, :gstin_number_proof, :business_address_proof)
  end
end
