# frozen_string_literal: true

describe OfferMeasurement, type: :model do
  it 'has a valid factory' do
    expect(create(:offer_measurement)).to be_valid
  end

  let(:offer_measurement) { create :offer_measurement }

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(offer_measurement).to validate_presence_of(:data) }
  end

  context 'ActiveRecord Associations' do
    it { expect(offer_measurement).to belong_to(:offer) }
  end

  context 'ActiveRecord Databases' do
    it { expect(offer_measurement).to have_db_column(:data).of_type(:jsonb).with_options(null: false) }
  end
end
