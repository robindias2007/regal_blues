# frozen_string_literal: true

describe ImageSerializer, type: :serializer do
  let(:image) { build(:image) }
  let(:image_serializer) { ImageSerializer.new(image) }

  it 'matches image' do
    expect(image_serializer.serializable_hash[:image]).to eq image.image
  end

  it 'matches width' do
    expect(image_serializer.serializable_hash[:width]).to eq image.width
  end

  it 'matches height' do
    expect(image_serializer.serializable_hash[:height]).to eq image.height
  end
end
