class UserChatType < ApplicationRecord

	def self.as_json offers
		offers.collect{|offer| {
	    id: offer.id,
	    designer_id: offer.designer_id,
	    request_id: offer.request_id,
	    created_at: offer.created_at,
	    updated_at: offer.updated_at,
	    offer_quotations: offer.offer_quotations.collect{|quotation| {
	    	id: quotation.id,
	    	price: quotation.price,
	    	description: quotation.description,
	    	created_at: quotation.created_at,
	    	updated_at: quotation.updated_at
	    }}
	   }}
	end

	def self.support_json
		Support.all.collect{|support| {
			id: support.id
		}}
	end
end
