# frozen_string_literal: true

class V1::Designers::RequestChatsController < V1::Designers::BaseController
  def create
    request_chat = current_designer.request_chats.find_or_initialize_by(request_chat_params)
    if request_chat.save
      render json: request_chat, serializer: V1::Designers::RequestChatSerializer, designer_id: current_designer.id
    else
      render json: { errors: request_chat.errors }, status: 400
    end
  end

  def show
    offers_ids = RequestChat.find(params[:id]).request.offers.where(designer: current_designer).pluck(:id)
    quotes = OfferQuotation.where(offer_id: offers_ids).order(created_at: :asc)
    render json: quotes, each_serializer: V1::Designers::RequestChatQuotationSerializer
  end

  private

  def request_chat_params
    params.require(:request_chat).permit(:request_id)
  end
end
