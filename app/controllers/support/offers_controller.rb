# frozen_string_literal: true

class Support::OffersController < ApplicationController
  def index
    @offers = Offer.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)
  end

  def show
    @offer = Offer.find(params[:id])
    @offer_quotations = @offer.offer_quotations
    @offer_quotation = OfferQuotation.new
    @image = Image.new
  end

  def create_quotation
    offer_quotation = OfferQuotation.new(offer_quotation_params)  
    if offer_quotation.save! 
      offer_gall = params[:offer_quotation][:offer_quotation_gallery]
      offer_quotation.offer_quotation_galleries.create!(name:offer_gall[:name])
      offer_gall[:image][:image].each do |f|
        offer_quotation.offer_quotation_galleries.first.images.create!(image:f)
      end
      redirect_to support_offer_path(offer_quotation.offer_id)
    else
      redirect_to root_url
    end
  end

  def update_quotation
    offer_quotation = OfferQuotation.find_by(offer_id:params[:offer_id])
    if params[:commit] == "Update Measurement"
      a = offer_quotation.offer_measurements.first
      a.data = JSON.parse params[:offer_measurement][:data].gsub('=>', ':')
      a.save!
    else
      offer_quotation.update(offer_quotation_params)
    end
    flash[:success] = "Offer Updated"
    redirect_to support_offer_path(params[:offer_id])
  end

  def gallery_images
    image = Image.new(gallery_image_params)
    #debugger
    if image.save!
      flash[:success] = "Image Uploaded"
      redirect_to request.referer
    else
      redirect_to support_offers_path
    end
  end

  private

  def offer_quotation_params
    params.require(:offer_quotation).permit(:price, :description, :request_id, :designer_note, :offer_id, offer_quotation_galleries_attributes: [:name ], images_attributes: %i[image] )
  end

  def gallery_image_params
    params.require(:image).permit(:image, :imageable_id, :imageable_type, :description, :serial_number)
  end
end
