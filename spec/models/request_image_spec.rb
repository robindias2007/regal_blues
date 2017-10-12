# frozen_string_literal: true

describe RequestImage, type: :model do
  let(:request_image) { create :request_image }

  it 'has a valid factory' do
    expect(create(:request_image)).to be_valid
  end
end
