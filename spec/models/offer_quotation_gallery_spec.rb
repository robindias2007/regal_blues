# frozen_string_literal: true

describe OfferQuotationGallery, type: :model do
  let(:offer_quotation_gallery) { create :offer_quotation_gallery }

  it 'has a valid factory' do
    expect(create(:offer_quotation_gallery)).to be_valid
  end

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(offer_quotation_gallery).to validate_presence_of(:name) }
    # Uniqueness Validations
    it do
      expect(offer_quotation_gallery).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:offer_quotation_id)
    end
  end

  context 'ActiveRecord Nested Attributes' do
    it { expect(offer_quotation_gallery).to accept_nested_attributes_for(:images) }
  end

  context 'ActiveRecord Associations' do
    it { expect(offer_quotation_gallery).to belong_to(:offer_quotation) }
  end

  context 'ActiveRecord Databases' do
    it { expect(offer_quotation_gallery).to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
