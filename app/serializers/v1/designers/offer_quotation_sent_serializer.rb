# frozen_string_literal: true

class V1::Designers::OfferQuotationSentSerializer < ActiveModel::Serializer
  attributes :id, :quotations

  def quotations
    object.offers.find_by(designer_id: @instance_options[:designer_id]).offer_quotations.map do |oq|
      ActiveModelSerializers::SerializableResource.new(oq,
        serializer: V1::Designers::OfferQuotationsSerializer).as_json
    end
  end
end
