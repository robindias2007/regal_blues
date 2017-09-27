# frozen_string_literal: true

class V1::Users::RequestsController < V1::Users::BaseController
  def create
    # binding.pry
    request = current_user.requests.build(request_params)
    if request.save
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
    render json: designers, each_serializer: V1::Users::RequestDesignerSerializer
  end

  def index
    requests = current_user.requests.order(created_at: :desc).limit(20)
    render json: { requests: requests }
  end

  def show
    request = current_user.requests.find(params[:id])
    render json: { request: request }
  end

  private

  def request_params
    params.require(:request).permit(:name, :size, :min_budget, :max_budget, :timeline, :address_id,
      :description, :sub_category_id, request_images_attributes:    %i[image color description],
                                      request_designers_attributes: %i[designer_id])
  end

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end
end
