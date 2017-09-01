# frozen_string_literal: true

class V1::Designers::OffersController < V1::Designers::BaseController
  def create
    offer = current_designer.offers.build(offer_params)
    if offer.save
      render json: { message: 'Offer saved successfully' }, status: 201
    else
      render json: { errors: offer.errors.messages }, status: 400
    end
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
