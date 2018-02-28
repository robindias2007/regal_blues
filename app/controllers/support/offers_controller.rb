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

  # def create_quotation
  #   @offer_quotation = OfferQuotation.new(offer_quotation_params)  
  #   @offer_quotation_gallery = @offer_quotation.offer_quotation_galleries.new(name:params[:offer_quotation][:offer_quotation_gallery][:name])
  #   @gallery_image =  @offer_quotation_gallery.images.new(image:params[:offer_quotation][:offer_quotation_gallery][:image], imageable_id:@offer_quotation_gallery.id)
  #   debugger
  #   if @offer_quotation.save! && @offer_quotation_gallery.save! && @gallery_image.save!
  #     @gallery_image.update()
  #     redirect_to request.referrer
  #   else
  #     redirect_to root_url
  #   end
  # end

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
