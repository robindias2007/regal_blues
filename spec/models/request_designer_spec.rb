# frozen_string_literal: true

describe RequestDesigner, type: :model do
  let(:request_designer) { create :request_designer }

  it 'has a valid factory' do
    expect(create(:request_designer)).to be_valid
  end

  context 'ActiveRecord Associations' do
    it { expect(request_designer).to belong_to(:designer) }
    it { expect(request_designer).to belong_to(:request) }
  end
end
