# frozen_string_literal: true

class Support::OffersController < ApplicationController
  def index
    @offers = Offer.all.order(created_at: :desc)
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
      debugger
      offer_quotation.offer_quotation_galleries.create!(name:offer_gall[:name])
      offer_gall[:image].each do |f|
        offer_quotation.offer_quotation_galleries.first.images.create!(image:f)
      end
    else
      redirect_to root_url
    end
  end

  def update_quotation
    offer_quotation = OfferQuotation.find_by(offer_id:params[:offer_id])
    offer_quotation.update(offer_quotation_params)
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
    params.require(:offer_quotation).permit(:price, :description, :request_id, :designer_note, :offer_id, offer_quotation_galleries_attributes: offer_quotation_galleries_attributes)
  end

  def offer_quotation_galleries_attributes
    [:name , :offer_id, images_attributes: %i[image description]]
  end

  def gallery_image_params
    params.require(:image).permit(:image, :imageable_id, :imageable_type)
  end
end
