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


  #Predefined Measurement Tags To Be Shown while quoting it.
  def measurement_tags
    measurement_tags =  %W[Bust Waist Hip #{"Cap Sleeve Length"} #{"Shoulder to Apex"}
    					#{"Short Sleeve Length"} #{"3/4 Sleeve Length"} #{"Full Sleeve Length"} 
    					#{"Front Neck Depth"} #{"Cross Under Bust"} #{"Lower Waist"} Wrist
    					#{"Thigh Round"} #{"Lower Thigh"} #{"Knee Round"} Calf #{"Ankle Round"} 
    					#{"Waist Length (waist to ankle)"} #{"Full Length Shoulder to Ankle"} 
    					#{"Bottom Length"} #{"Elbow Round"} Bicep #{"Back Neck Depth"} #{"Shoulder Neck Round"} 
    					#{"Arm Hole"} ]
    render json: { data: measurement_tags }
  end

end
