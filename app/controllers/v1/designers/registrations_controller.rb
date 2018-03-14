# frozen_string_literal: true

class V1::Designers::RegistrationsController < V1::Designers::BaseController
  include Registerable

  def update_store_info
    store_info = current_designer.build_designer_store_info(store_info_params)
    if store_info.save
      render json: { message: 'Store info successfully updated' }, status: 201
    else
      render json: { errors: ['Something went wrong'] }, status: 400
    end
  end

  def update_finance_info
    finance_info = current_designer.build_designer_finance_info(finance_info_params)
    if finance_info.save
      render json: { message: 'Store info successfully updated' }, status: 201
    else
      render json: { errors: finance_info.errors, message: ['Something went wrong'] }, status: 400
    end
  end

  def bank_details
    details = DesignerFinanceInfo.bank_details(params[:ifsc_code])
    if details.code == 200
      render json: details.body
    else
      render json: { errors: 'Not a valid IFSC code' }, status: 400
    end
  end

  def list_categories
    categories = SubCategory.all.order(serial_no: :asc)
    render json: categories, each_serializer: V1::Designers::SubCategorySerializer
  end

  def associate_categories
    current_designer.designer_categorizations.create!(designer_categories_params)
    render json: { message: 'Designer associated with the categories' }, status: 201
  end

  def toggle_active
    if current_designer.safe_toggle!(:active)
      render json: { message: 'Designer state successfully changed' }
    else
      render json: { errors: current_designer.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def profile
    render json: current_designer, serializer: V1::Designers::ProfileSerializer
  end

  def update_profile
    if current_designer.update(update_profile_params)
      render json: { message: 'Designer profile successfully updated' }
    else
      render json: { errors: current_designer.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def send_update_otp
    if current_designer.send_update_otp(params[:mobile_number])
      render json: { msg: 'OTP sent successfully' }
    else
      render json: { errors: current_designer.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def resend_update_otp
    number_hash = Redis.current.get(current_designer.id)
    return wrong_number if number.blank?
    if current_designer.send_update_otp(number_hash.fetch(:number))
      render json: { msg: 'OTP resent successfully' }
    else
      render json: { errors: current_designer.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def verify_updated_number
    number_hash = Redis.current.get(current_designer.id)
    if number_hash.fetch(:otp) == params[:otp]
      current_designer.update(verified: true, mobile_number: number_hash.fetch(:number))
      render json: { message: 'Mobile number updated and verified' }, status: 200
    else
      render json: { errors: current_designer.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def update_profile_password
    return wrong_old_password unless matches_password(params[:old_password])
    if current_designer.update(password: params[:new_password])
      render json: { message: 'Password Updated' }, status: 200
    else
      render json: { errors: ['Something went wrong'] }, status: 400
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

  def update_profile_params
    params.require(:designer).permit(:bio, :location, :avatar,
      designer_store_info_attributes: %i[id min_order_price])
  end

  def designer_categories_params
    params.require(:designer).permit!.fetch(:data)
  end

  def wrong_number
    render json: { error: 'Number does not exist' }, status: 400
  end

  def wrong_old_password
    render json: { errors: 'Old password does not match the password in the records' }, status: 400
  end

  def matches_password(password)
    BCrypt::Password.new(current_resource.password_digest) == password
  end
end
