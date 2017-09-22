# frozen_string_literal: true

describe V1::Users::RequestSubCategorySerializer, type: :serializer do
  let(:sub_category) { build(:sub_category) }
  let(:sub_category_serializer) { V1::Users::RequestSubCategorySerializer.new(sub_category) }

  it 'matches display name' do
    expect(sub_category_serializer.serializable_hash[:name]).to eq sub_category.name
  end

  it 'matches store image' do
    expect(sub_category_serializer.serializable_hash[:image]).to eq sub_category.image
  end
end
