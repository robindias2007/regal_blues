# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  include PushNotification
  before_action :find_request_designer, only: %i[toggle_not_interested mark_involved]

  def index
    requests = Request.find_for(current_designer).where(status: "active").order(created_at: :desc)
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
    if @request_designer.safe_toggle!(:not_interested)
      render json: { message: 'Request has been successfully updated as not interested' }, status: 200
    else
      render json: { errors: @request_designer.errors }, status: 400
    end
  end

  def mark_involved
    return invalid_option_for_involved if @request_designer.involved == true
    if @request_designer.update(involved: true)
      notify_involved(@request_designer)
      render json: { message: 'Request has been successfully updated as involved' }, status: 200
    else
      render json: { errors: @request_designer.errors }, status: 400
    end
  end

  def destroy
    if Request.find(params[:id]).destroy
      render json: { message: 'Request has been deleted for the designer' }
    else
      render json: { errors: @request_designer.errors }
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
    @request_designer ||= RequestDesigner.find_for(params[:id], current_designer)
  end

  def invalid_option_for_involved
    render json: { error: 'This designer has already marked this request as involved' }, status: 400
  end

  def notify_involved(request_designer)
    begin
      #hours, minutes
      timer = [48, 72, 84]
      request_designer.delay(run_at: 96.hours.from_now).penalty_msg
      timer.each do |time|
        request_designer.delay(run_at: time.hours.from_now).quote_msg(time)
      end
    rescue
    end
  end
end
