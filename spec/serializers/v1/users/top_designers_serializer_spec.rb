# frozen_string_literal: true

describe V1::Users::TopDesignersSerializer, type: :serializer do
  let(:designer_store_info) { build :designer_store_info }
  let(:designer) { designer_store_info.designer }
  let(:designer_serializer) { V1::Users::TopDesignersSerializer.new(designer) }

  it 'matches min price' do
    expect(designer_serializer.serializable_hash[:min_price]).to eq designer.designer_store_info.min_order_price.round
  end

  it 'matches name' do
    expect(designer_serializer.serializable_hash[:name]).to eq designer.designer_store_info.display_name
  end
end
