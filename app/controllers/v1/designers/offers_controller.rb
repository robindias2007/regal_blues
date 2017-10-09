# frozen_string_literal: true

class V1::Designers::OffersController < V1::Designers::BaseController
  def create
    offer = current_designer.offers.build(offer_params)
    if offer.save
      # TODO: Send a notification to the user and the support team
      render json: { message: 'Offer saved successfully' }, status: 201
    else
      render json: { errors: offer.errors.messages }, status: 400
    end
  end

  def index
    offers = current_designer.offers.order(created_at: :desc).limit(20)
    render json: { offers: offers }
  end

  def show
    offer = current_designer.offers.find(params[:id])
    render json: { offer: offer }
  end

  private

  def offer_params
    params.require(:offer).permit(:request_id, offer_quotations_attributes:   offer_quotations_attributes,
                                               offer_measurements_attributes: [data: {}])
  end

  def offer_quotations_attributes
    [:price, :description, offer_quotation_galleries_attributes: [:name, images_attributes: [:image]]]
  end
end
