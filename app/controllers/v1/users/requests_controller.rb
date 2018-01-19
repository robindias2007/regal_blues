# frozen_string_literal: true

class V1::Users::RequestsController < V1::Users::BaseController
  def create
    request = current_user.requests.build(request_params)
    return no_designers_selected if params[:request][:request_designers_attributes].empty?
    if request.save! && request.request_designers.create!(request_designers_params['request_designers_attributes'])
      request.send_request_mail
      # RequestDesignerService.notify_about request
      render json: { message: 'Request saved successfully' }, status: 201
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def init_data
    categories = SubCategory.all.order(name: :asc)
    addresses = current_user.addresses.order(nickname: :asc).limit(10)
    json = {
      categories: serialization_for(categories, V1::Users::RequestSubCategorySerializer),
      addresses:  serialization_for(addresses, V1::Users::AddressSerializer)
    }
    render json: json
  end

  def designers
    designers = Designer.find_for_category(params[:category_id])
    if designers.present?
      render json: designers, each_serializer: V1::Users::RequestDesignerSerializer
    else
      render json: { message: 'No designers found!' }, status: 404
    end
  end

  def index
    requests = current_user.requests.order(updated_at: :desc).limit(20)
    if requests.present?
      render json: requests, each_serializer: V1::Users::RequestsSerializer
    else
      render json: { message: 'No requests found!' }, status: 404
    end
  end

  def show
    request = current_user.requests.find(params[:id])
    render json: request, serializer: V1::Users::RequestShowSerializer
  end

  private

  def request_params
    params.require(:request).permit(:name, :size, :min_budget, :max_budget, :timeline, :address_id, :origin,
      :description, :sub_category_id, request_images_attributes:    %i[image color description serial_number])
  end

  def request_designers_params
    params.require(:request).permit(request_designers_attributes: [:designer_id])
  end

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end

  def no_designers_selected
    render json: { error: 'No designers selected' }, status: 400
  end
end
