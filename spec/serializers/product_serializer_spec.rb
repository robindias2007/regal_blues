# frozen_string_literal: true

describe ProductSerializer, type: :serializer do
  let(:product) { build(:product) }
  let(:product_serializer) { ProductSerializer.new(product) }

  it 'matches name' do
    expect(product_serializer.serializable_hash[:name]).to eq product.name
  end

  it 'matches description' do
    expect(product_serializer.serializable_hash[:description]).to eq product.description
  end

  it 'matches selling price' do
    expect(product_serializer.serializable_hash[:selling_price]).to eq product.selling_price
  end

  it 'matches active' do
    expect(product_serializer.serializable_hash[:active]).to eq product.active
  end
end
