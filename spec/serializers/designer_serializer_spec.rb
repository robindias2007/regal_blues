# frozen_string_literal: true

describe DesignerSerializer, type: :serializer do
  let(:designer) { build(:designer) }
  let(:designer_serializer) { DesignerSerializer.new(designer) }

  it 'matches mobile number' do
    expect(designer_serializer.serializable_hash[:mobile_number]).to eq designer.mobile_number
  end

  it 'matches full name' do
    expect(designer_serializer.serializable_hash[:full_name]).to eq designer.full_name
  end
end
