# frozen_string_literal: true

describe V1::Users::RequestsSerializer, type: :serializer do
  let(:request) { build(:request) }
  let(:request_serializer) { V1::Users::RequestsSerializer.new(request) }

  it 'matches item type' do
    expect(request_serializer.serializable_hash[:item_type]).to eq SubCategory.find(request.sub_category_id).name
  end

  it 'matches offers count' do
    expect(request_serializer.serializable_hash[:offers_count]).to eq request.offers.count
  end
end
