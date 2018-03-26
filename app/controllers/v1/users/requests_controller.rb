# frozen_string_literal: true

class V1::Users::RequestsController < V1::Users::BaseController
  def create
    request = current_user.requests.build(request_params)
    return no_designers_selected if params[:request][:request_designers_attributes].empty?
    if request.save! && request.request_designers.create!(request_designers_params['request_designers_attributes'])
      request.delay.send_request_mail
      current_user.update(mobile_number:params[:request][:mobile_number])
      # RequestDesignerService.notify_about request
      render json: { message: 'Request saved successfully' }, status: 201
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def create_v2
    request = current_user.requests.build(request_v2_params)
    return no_designers_selected if params[:request][:request_designers_attributes].empty?
    if request.save! && request.request_designers.create!(request_designers_params['request_designers_attributes'])
      request.delay.send_request_mail
      current_user.update(mobile_number:params[:request][:mobile_number])
      render json: {request_id: request.id }, status: 201
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def create_request_images_v2
    request = Request.find(params[:id])
    if request.present?
      params["request_images_attributes"].each do |f|
        request.request_images.create!(image:f["image"], serial_number:f["serial_number"], description:f["description"])
      end
      render json: { message: 'Request Images Saved Successfully' }, status: 201
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def init_data
    categories = SubCategory.all.order(serial_no: :asc)
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
    #requests = current_user.requests.order(updated_at: :desc).limit(20)

    r1 = current_user.requests.where.not(status:["unapproved","confirmed"]).includes(:offers).where.not( :offers => { :request_id => nil } ).order(updated_at: :desc)
    r2 = current_user.requests.order(updated_at: :desc)
    r3 = (r2 - r1)
    requests = r1 + r3.sort {|x,y| x[:status]<=>y[:status]}
    if requests.present?
      render json: requests, each_serializer: V1::Users::RequestsSerializer
      #render json: { requests: request_resource(requests) }
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

  def request_v2_params
    params.require(:request).permit(:name, :size, :min_budget, :max_budget, :timeline, :address_id, :origin,
      :description, :sub_category_id, :urls => [], request_images_attributes:    %i[image color description serial_number])
  end

  def request_images_v2_params
    params.require(:request).permit(request_images_attributes:    %i[image color description serial_number])
  end

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end

  def no_designers_selected
    render json: { error: 'No designers selected' }, status: 400
  end
end
