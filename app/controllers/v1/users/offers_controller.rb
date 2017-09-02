# frozen_string_literal: true

class V1::Users::OffersController < V1::Users::BaseController
  def index
    offers = request_conditional_offers.order(created_at: :desc).limit(20)
    render json: { offers: offers }
  end

  def show
    offer = Offer.find_for_user(current_user).find(params[:id])
    render json: { offer: offer }
  end

  private

  def request_conditional_offers
    if params[:request_id].present?
      Offer.find_for_user_and_request(current_user, params[:request_id])
    else
      Offer.find_for_user(current_user)
    end
  end
end
