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

  context 'ActiveRecord Nested Attributes' do
    it { expect(offer).to accept_nested_attributes_for(:offer_quotations) }
  end

  context 'ActiveRecord Associations' do
    it { expect(offer).to belong_to(:designer) }
    it { expect(offer).to belong_to(:request) }
    it { expect(offer).to have_many(:offer_quotations) }
    it { expect(offer).to have_many(:offer_measurements) }
  end
end
