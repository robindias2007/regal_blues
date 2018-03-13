# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  #before_action :authenticate_support, :only => [:index]
  
  def index
    order_name_array = []     
    Order.all.each do |f|
      order_name_array << f.offer_quotation.offer.request.name
    end
    second_last = Request.where(name:order_name_array)
    first = Request.where(id: Request.all - second_last)

    requests = first.where(status:"active").order(created_at: :desc) + first.where(status:"unapproved").order(created_at: :desc) + second_last

    @requests = Request.where(id:requests).order(status: :asc).order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)
  end

  def create
    request = User.find(params[:request][:user_id]).requests.build(request_params)
    unless request.user.addresses.present?
      a = params[:request][:addresses]
      address = request.user.addresses.create!(street_address:a[:street_address], nickname:a[:street_address],city:a[:city], state:a[:state], country:a[:country], pincode:a[:pincode])  
      request.update(address_id:address.id)
    end
    if request.save!
      params[:request][:request_image][:image].each do |f|
        request.request_images.create!(image:f, serial_number:1)  
      end
      if params[:request][:request_designer][:designer_id].present?
        request.request_designers.create!(request_id:request.id, designer_id:params[:request][:request_designer][:designer_id])
      else
        Designer.all.pluck(:id).each do |f|   
          request.request_designers.create!(request_id:request.id, designer_id:f)
        end
      end
      # RequestDesignerService.notify_about request
      request.delay.send_request_mail
      redirect_to support_requests_path
      flash[:success] = "Request Successfully Created"
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def chat
    @skip_header = true;
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    update_read_count = Conversation.find(@convo_id.id).messages.update_all(read:true)
  end

  def chat_post
    conversation = Conversation.find(params[:id])    
    @message = conversation.messages.new(message_params)
    @message.sender_id = current_support.common_id
    if @message.save!
      conversation.update(updated_at:DateTime.now)
      conversation.conversationable.update(updated_at:DateTime.now)
      redirect_to chat_path(@message.conversation_id)
    else
      flash[:notice] = "Chat Not Processed"
      redirect_to root_url
    end
  end

  def show
    @conversation = Conversation.new
    @request_image = RequestImage.new
    @request = Request.find(params[:id])
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@request.user).first 
  end

  def update
    request = Request.find(params[:id])
    req = params[:request]
    request.update(description:req[:description], max_budget:req[:max_budget], support_notes:req[:support_notes])
    if params[:request][:hot] == "1"
      request.update(hot:true, cold:false, warm:false)
    elsif params[:request][:cold] == "1"
      request.update(hot:false, cold:true, warm:false)
    elsif params[:request][:warm] == "1"
      request.update(hot:false, cold:false, warm:true)        
    end
    flash[:success] = "Request Updated"
    redirect_to support_request_path(request) 
  end

  def approve
    request = Request.find(params[:support_request_id])
    request.update!(status: :active)
    render json: { message: 'Request approved' }, status: 200
  end

  def reject
    request = Request.find(params[:support_request_id])
    request.update!(status: :unapproved)
    render json: { message: 'Request unapproved' }, status: 200
  end

  def show_request_quo
    @request = Request.find(params[:id])
  end

  def request_images
    request_image = RequestImage.new(request_image_params)
    if request_image.save!
      flash[:success] = "Image Uploaded"
      redirect_to request.referer
    else
      redirect_to support_requests_path
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :attachment, :conversation_id)
  end

  def request_image_params
    params.require(:request_image).permit(:image, :request_id, :color, :serial_number)
  end

  def request_params
    params.require(:request).permit(:user_id, :name, :size, :min_budget, :max_budget, :timeline, :address_id, :origin,
      :description, :sub_category_id, request_images_attributes:    %i[image color description serial_number],
      request_designers_attributes: [:designer_id])
  end

  def request_designers_params
    params.require(:request).permit(request_designers_attributes: [:designer_id])
  end


end
