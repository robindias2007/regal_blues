# frozen_string_literal: true

describe OfferQuotation, type: :model do
  it 'has a valid factory' do
    expect(create(:offer_quotation)).to be_valid
  end

  let(:offer_quotation) { create :offer_quotation }

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(offer_quotation).to validate_presence_of(:price) }
    it { expect(offer_quotation).to validate_presence_of(:description) }
    # Length Validations
    it { expect(offer_quotation).to validate_length_of(:description).is_at_least(4).is_at_most(480) }
    # Numericality Validations
    it { expect(offer_quotation).to validate_numericality_of(:price) }
  end

  context 'ActiveRecord Associations' do
    it { expect(offer_quotation).to belong_to(:offer) }
  end

  context 'ActiveRecord Databases' do
    it { expect(offer_quotation).to have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { expect(offer_quotation).to have_db_column(:description).of_type(:text).with_options(null: false) }
  end
end
