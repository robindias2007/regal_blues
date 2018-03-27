class Support::ReportsController < ApplicationController
	
	# List of all reports 
	def list_reports
	end

	#requests 24hours
	def requests_24
		@requests = Request.where(created_at: 24.hours.ago..Time.now)
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	#requests 48hours
	def requests_48
		@requests = Request.where(created_at: 48.hours.ago..Time.now)
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end	

	# Users who have not responded to offers sent in ​last 24 hours
	def user_nooffer_24
		requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
		users = Array.new
		if requests.present?
			requests.each do |f|
				offer = f.offers.first.created_at.to_date rescue nil
				if (offer == Date.today ) || (offer == Date.yesterday)
					unless f.status == "confirmed"
						users.push(f.user)
					end
				end
			end
		end
		@users = User.where(id:users)
		respond_to do |format|
      format.csv {send_data @users.to_csv}
    end
	end

	# Users who have not responded to offers sent in ​last 48 hours
	def user_nooffer_48
		requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
		users = Array.new
		if requests.present?
			requests.each do |f|
				offer = f.offers.first.created_at.to_date rescue nil
				if (offer == Date.today) || (offer == Date.yesterday) || ( offer == 2.days.ago)
					unless f.status == "confirmed"
						users.push(f.user)
					end
				end
			end
		end
		@users = User.where(id:users)
		respond_to do |format|
      format.csv {send_data @users.to_csv}
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

	#hot users
	def hot_users
		@users =  User.where(hot:true)
		respond_to do |format|
      format.csv {send_data @users.to_csv}
    end
	end

	#warm_users
	def warm_users
		@users =  User.where(warm:true)
		respond_to do |format|
      format.csv {send_data @users.to_csv}
    end
	end

	#cold_users
	def cold_users
		@users =  User.where(cold:true)
		respond_to do |format|
      format.csv {send_data @users.to_csv}
    end
	end

	# Requests With Offers
	def offer_requests
		@requests = Request.includes(:offers).where.not( :offers => { :request_id => nil } )
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests With No Offers 24 hours
	def no_offer_requests_24
		requests = Request.includes(:offers).where( :offers => { :request_id => nil } )
		req = []
		if requests.present?
			requests.each do |f|
				if (f.created_at.to_date == Date.today) || (f.created_at.to_date == Date.yesterday)
					req.push(f)
				end
			end
		end
		@requests = Request.where(id:req)
		respond_to do |format|
      format.csv {send_data @requests.to_csv}
    end
	end

	# Requests With No Offers 48 hours
	def no_offer_requests_48
		requests = Request.includes(:offers).where( :offers => { :request_id => nil } )
		req = []
		if requests.present?
			requests.each do |f|
				if (f.created_at.to_date == Date.today) || (f.created_at.to_date == Date.yesterday) || (f.created_at.to_date == 2.days.ago)
					req.push(f)
				end
			end
		end
		@requests = Request.where(id:req)
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

end