# frozen_string_literal: true

describe RequestDesigner, type: :model do
  it 'has a valid factory' do
    expect(create(:request_designer)).to be_valid
  end

  let(:request_designer) { create :request_designer }

  context 'ActiveRecord Associations' do
    it { expect(request_designer).to belong_to(:designer) }
    it { expect(request_designer).to belong_to(:request) }
  end
end
