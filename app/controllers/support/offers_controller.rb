# frozen_string_literal: true

class Support::OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def show
    @offer = Offer.find(params[:id])
    @offer_quotations = @offer.offer_quotations
  end
end
