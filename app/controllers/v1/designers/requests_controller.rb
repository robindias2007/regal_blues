# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  before_action :find_request, only: %i[show not_interested]

  def index
    requests = Request.find_for(current_designer).order(created_at: :desc).limit(20)
    if requests.present?
      render json: requests, each_serializer: V1::Designers::RequestIndexSerializer, meta: first_instance_of(requests)
    else
      render json: { message: 'No requests found!' }, status: 404
    end
  end

  def show
    render json: @request, serializer: V1::Designers::RequestShowSerializer,
      meta: { interested: !RequestDesigner.find_by(designer: current_designer, request: @request).not_interested? }
  end

  def toggle_not_interested
    if @request.toggle(:not_interested)
      render json: { message: 'Request has been successfull updated as not interested' }, status: 200
    else
      render json: { errors: @request.errors.messages }, status: 400
    end
  end

  private

  def find_request
    @request ||= Request.find_for(current_designer).find(params[:id])
  end

  def first_instance_of(requests)
    ActiveModelSerializers::SerializableResource.new(requests.first,
      serializer: V1::Designers::RequestShowSerializer)
  end
end
