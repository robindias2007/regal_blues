# frozen_string_literal: true

class V1::Users::RequestChatQuotationSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :price

  def designer_name
    object.offer.designer.designer_store_info.display_name
  end
end
