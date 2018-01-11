# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  include PushNotification
  before_action :find_request_designer, only: %i[toggle_not_interested mark_involved]

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
    if @request_designer.safe_toggle!(:not_interested)
      render json: { message: 'Request has been successfully updated as not interested' }, status: 200
    else
      render json: { errors: @request_designer.errors }, status: 400
    end
  end

  def mark_involved
    return invalid_option_for_involved if @request_designer.involved == true
    if @request_designer.update(involved: true)
      NotificationsMailer.interested(@request_designer, 48).deliver_later
      NotificationsMailer.interested(@request_designer, 24).deliver_later(wait: 24.hour)
      NotificationsMailer.interested(@request_designer, 12).deliver_later(wait: 12.hour)
      begin
        body = "48 hrs left to send quote for the request"
        @request_designer.designer.notifications.create(body: body, notification_type: "request")
        send_notification(@request_designer.designer.devise_token, body, body)
      rescue
      end
      
      NotificationsMailer.penalty(@request_designer).deliver_later(wait: 48.hour)
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
end
