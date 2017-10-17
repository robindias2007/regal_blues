# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  before_action :find_request_designer, only: %i[toggle_not_interested destroy]

  def index
    requests = Request.find_for(current_designer).order(created_at: :desc)
    if requests.present?
      render json: requests, each_serializer: V1::Designers::RequestIndexSerializer, meta: first_instance_of(requests),
      designer_id: current_designer.id
    else
      render json: { message: 'No requests found!' }, status: 404
    end
  end

  def show
    request = Request.find_for(current_designer).find(params[:id])
    render json: request, serializer: V1::Designers::RequestShowSerializer,
      meta: meta_value(request), designer_id: current_designer.id
  end

  def toggle_not_interested
    if @request.safe_toggle!(:not_interested)
      render json: { message: 'Request has been successfully updated as not interested' }, status: 200
    else
      render json: { errors: @request.errors }, status: 400
    end
  end

  def destroy
    if @request.destroy
      render json: { message: 'Request has been deleted for the designer' }
    else
      render json: { errors: @request.errors }
    end
  end

  private

  def first_instance_of(requests)
    ActiveModelSerializers::SerializableResource.new(requests.first,
      serializer: V1::Designers::RequestShowSerializer)
  end

  def meta_value(request)
    if offers?(request)
      {
        offers: ActiveModelSerializers::SerializableResource.new(request,
          serializer: V1::Designers::OfferQuotationSentSerializer, designer_id: current_designer.id).as_json
      }
    else
      {}
    end
  end

  def offers?(request)
    Offer.where(request: request, designer: current_designer).any?
  end

  def find_request_designer
    @request ||= RequestDesigner.find_for(params[:id], current_designer)
  end
end
