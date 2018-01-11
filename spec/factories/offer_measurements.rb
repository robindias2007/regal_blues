# frozen_string_literal: true

FactoryGirl.define do
  factory :offer_measurement do
    data { { attributes: %w[Bust Waist Hip #{"Cap Sleeve Length"} #{"Shoulder to Apex"} #{"Short Sleeve Length"}
    	#{"3/4 Sleeve Length"} #{"Full Sleeve Length"} #{"Front Neck Depth"} #{"Cross Under Bust"} #{"Lower Waist"} Wrist
    	#{"Thigh Round"} #{"Lower Thigh"} #{"Knee Round"} Calf #{"Ankle Round"} #{"Waist Length (waist to ankle)"}
    	#{"Full Length Shoulder to Ankle"} #{"Bottom Length"} #{"Elbow Round"} Bicep #{"Back Neck Depth"} #{"Shoulder Neck Round"} #{"Arm Hole"} ] } }
    offer_quotation
  end
end
