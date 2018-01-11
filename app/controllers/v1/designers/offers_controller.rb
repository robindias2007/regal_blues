# frozen_string_literal: true

class V1::Designers::OffersController < V1::Designers::BaseController
  include PushNotification
#   def create
#     return already_created if offer_by_designer_present?
#     offer = current_designer.offers.build(offer_params)
    
#     req =  Request.find(params[:request_id])
# <<<<<<< HEAD
#     req1 = Offer.where(request_id:req.id)
    
# =======
#     puts req
#     req1 = Offer.where(request_id: req.id).first
# >>>>>>> 41b879b77ef2deec5b0e32c8a57bd12643b1c032
#     if req.address.country == "India" 
#       OfferQuotation.where(offer_id:req1).first.update(shipping_price:500)
#     else
#       OfferQuotation.where(offer_id:req1).first.update(shipping_price:1400)
# <<<<<<< HEAD
#     end  
# =======
#     end 
# >>>>>>> 41b879b77ef2deec5b0e32c8a57bd12643b1c032

#     if offer.save       

#       # TODO: Send a notification to the user and the support team
#       NotificationsMailer.new_offer(offer).deliver
#       begin
#         body = "You have a new offer"
#         offer.request.user.notifications.create(body: body, notification_type: "offer")
#         send_notification(offer.request.user.devise_token, body, body)
#       rescue
#       end
#       render json: { message: 'Offer saved successfully' }, status: 201
#     else
#       render json: { errors: offer.errors.messages }, status: 400
#     end


#   end

 def create
    return already_created if offer_by_designer_present?
    offer = current_designer.offers.build(offer_params)
    
    req =  Request.find(params[:request_id])
    req1 = Offer.where(request_id: req.id).first
    if req.address.country == "India" 
      OfferQuotation.where(offer_id:req1).first.update(shipping_price:500)
    else
      OfferQuotation.where(offer_id:req1).first.update(shipping_price:1400)
    end 

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
