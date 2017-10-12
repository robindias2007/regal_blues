# frozen_string_literal: true

describe OfferMeasurement, type: :model do
  let(:offer_measurement) { create :offer_measurement }

  it 'has a valid factory' do
    expect(create(:offer_measurement)).to be_valid
  end

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(offer_measurement).to validate_presence_of(:data) }
  end

  context 'ActiveRecord Associations' do
    it { expect(offer_measurement).to belong_to(:offer_quotation) }
  end

  context 'ActiveRecord Databases' do
    it { expect(offer_measurement).to have_db_column(:data).of_type(:jsonb).with_options(null: false) }
  end
end
