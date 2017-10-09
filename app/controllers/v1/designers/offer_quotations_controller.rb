# frozen_string_literal: true

class V1::Designers::OfferQuotationsController < V1::Designers::BaseController
  def index
    quotations = current_designer.offers.find(params[:offer_id]).offer_quotations
    render json: quotations
  end

  def show
    quotation = current_designer.offers.find(params[:offer_id]).offer_quotations.find(params[:id])
    render json: quotation
  end
end
