# frozen_string_literal: true

describe Offer, type: :model do
  it 'has a valid factory' do
    expect(create(:offer)).to be_valid
  end

  let(:offer) { create :offer }

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(offer).to validate_presence_of(:request_id) }
    it { expect(offer).to validate_presence_of(:designer_id) }
    # Uniqueness Validations
    it { expect(offer).to validate_uniqueness_of(:designer_id).case_insensitive.scoped_to(:request_id) }
  end
end
