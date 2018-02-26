# frozen_string_literal: true

class Support::OffersController < ApplicationController
  def index
    @offers = Offer.all.order(created_at: :desc)
  end

  def show
    @offer = Offer.find(params[:id])
    @offer_quotations = @offer.offer_quotations
    @offer = Offer.new
  end

  def create
    return already_created if offer_by_designer_present?
    offer = current_designer.offers.build(offer_params)
    if offer.save
      offer.update_shipping_price
      notify_new_offer(offer)
      render json: { message: 'Offer saved successfully' }, status: 201
    else
      render json: { errors: offer.errors.messages }, status: 400
    end
  end

  private

  def offer_quotation_params
  end
end
