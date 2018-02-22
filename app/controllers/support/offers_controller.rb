# frozen_string_literal: true

class Support::OffersController < ApplicationController
  def index
    @offers = Offer.all.order(created_at: :desc)
  end

  def show
    @offer = Offer.find(params[:id])
    @offer_quotations = @offer.offer_quotations
  end
end
