# frozen_string_literal: true

class V1::Designers::OfferQuotationChatsController < V1::Designers::BaseController
  def create
    offer_quotation_chat = current_designer.offer_quotation_chats
                                           .find_or_initialize_by(offer_quotation_chat_params)
    offer_quotation_chat.user = offer_quotation_chat.offer_quotation.offer.request.user
    if offer_quotation_chat.save
      render json: offer_quotation_chat, serializer: V1::Designers::OfferQuotationChatSerializer,
        designer_id: current_designer.id
    else
      render json: { errors: offer_quotation_chat.errors }, status: 400
    end
  end

  private

  def offer_quotation_chat_params
    params.require(:offer_quotation_chat).permit(:offer_quotation_id)
  end
end
