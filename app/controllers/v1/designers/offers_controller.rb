# frozen_string_literal: true

class V1::Designers::OffersController < V1::Designers::BaseController
  include PushNotification
  def create
    return already_created if offer_by_designer_present?
    offer = current_designer.offers.build(offer_params)
    # offer1 = Offer.where(request_id:params[:request_id]).first
    # if (offer1.request.address.country == "India") || (offer1.request.address.country == "india")
    #     OfferQuotation.where(offer_id:offer1.id).update(shipping_price:500)
    # else
    #   OfferQuotation.where(offer_id:offer1.id).update(shipping_price:1400)
    # end
    if offer.save  
      # TODO: Send a notification to the user and the support team
      NotificationsMailer.new_offer(offer).deliver
      begin
        body = "You have a new offer"
        offer.request.user.notifications.create(body: body, notification_type: "offer")
        send_notification(offer.request.user.devise_token, body, body)
      rescue
      end
      render json: { message: 'Offer saved successfully' }, status: 201
    else
      render json: { errors: offer.errors.messages }, status: 400
    end
  end

  def index
    offers = current_designer.offers.order(created_at: :desc).limit(20)
    render json: offers
  end

  def show
    offer = current_designer.offers.find(params[:id])
    render json: offer
  end

  private

  def offer_params
    params.require(:offer).permit(:request_id, offer_quotations_attributes: offer_quotations_attributes)
  end

  def offer_quotations_attributes
    [:price, :description,:shipping_price, offer_quotation_galleries_attributes: [:name, images_attributes: %i[image description]],
                           offer_measurements_attributes:        [data: {}]]
  end

  def already_created
    render json: { error: 'Offer has already been submitted' }, status: 400
  end

  def offer_by_designer_present?
    Offer.exists?(designer: current_designer, request_id: params[:offer][:request_id])
  end
end
