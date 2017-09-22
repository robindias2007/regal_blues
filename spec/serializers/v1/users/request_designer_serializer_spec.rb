# frozen_string_literal: true

describe V1::Users::RequestDesignerSerializer, type: :serializer do
  let(:designer) { build(:designer) }
  let(:designer_store_info) { build(:designer_store_info, designer: designer) }
  let(:designer_serializer) { V1::Users::RequestDesignerSerializer.new(designer) }

  before do
    _ = designer_store_info
  end

  it 'matches display name' do
    expect(designer_serializer.serializable_hash[:display_name]).to eq designer.designer_store_info.display_name
  end

  it 'matches store cover' do
    expect(designer_serializer.serializable_hash[:store_cover]).to eq designer.avatar
  end
end
