# frozen_string_literal: true

describe RequestImage, type: :model do
  it 'has a valid factory' do
    expect(create(:request_image)).to be_valid
  end

  let(:request_image) { create(:request_image) }

  context 'ActiveRecord Associations' do
    it { expect(request_image).to belong_to(:request) }
    it { expect(request_image).to have_many(:images) }
  end
end
