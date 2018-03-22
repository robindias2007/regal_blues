class Support::ReportsController < ApplicationController
	
	# List of all reports 
	def list_reports
	end

	# Requests With Offers
	def offer_requests
		@requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests With No Offers
	def no_offer_requests
		@requests = Request.includes(:offers).where( :offers => { :request_id => nil } )
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests with no offers with budget more then 10000 15 days ago
	def requests_nooffers_10000
		@requests = Request.where("max_budget < 10000").where(created_at: 15.days.ago..Time.now).includes(:offers).where( :offers => { :request_id => nil } )
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests with no offers with budget between 10000 to 15000. 15 days ago
	def requests_nooffers_10_15
		@requests = Request.where(max_budget: 10000..15000).where(created_at: 15.days.ago..Time.now).includes(:offers).where( :offers => { :request_id => nil } )
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests with no offers with budget more then 15000. 15 days ago
	def requests_nooffers_15000
		@requests = Request.where("max_budget > 15000").where(created_at: 15.days.ago..Time.now).includes(:offers).where( :offers => { :request_id => nil } )
		respond_to do |format|
      		format.csv {send_data @requests.to_csv}
    	end
	end


	# Awaiting Measurements 7 days ago from today
	def awating_meas
		order_name_array = Array.new
		Order.where(status:"designer_confirmed").where(created_at: 15.days.ago..Time.now).each do |order|
			order_name_array.push(order.offer_quotation.offer.request)
		end
		@requests = Request.where('id in (?)',order_name_array.pluck(:id))	
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end
end