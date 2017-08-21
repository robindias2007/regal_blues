# frozen_string_literal: true

describe ProductImage, type: :model do
  it 'has a valid factory' do
    expect(create(:product_image)).to be_valid
  end

  let(:product_image) { create(:product_image) }

  context 'ActiveRecord Associations' do
    it { expect(product_image).to belong_to(:product) }
    it { expect(product_image).to have_many(:images) }
  end
end
