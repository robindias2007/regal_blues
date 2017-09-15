# frozen_string_literal: true

describe Address, type: :model do
  let(:address) { create :address }

  it 'has a valid factory' do
    expect(create(:address)).to be_valid
  end

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(address).to validate_presence_of(:country) }
    it { expect(address).to validate_presence_of(:pincode) }
    it { expect(address).to validate_presence_of(:street_address) }
    it { expect(address).to validate_presence_of(:city) }
    it { expect(address).to validate_presence_of(:state) }
    it { expect(address).to validate_presence_of(:nickname) }
    # Uniqueness Validations
    it { expect(address).to validate_uniqueness_of(:street_address).case_insensitive.scoped_to(:user_id) }
  end

  context 'ActiveRecord databases' do
    it { expect(address).to have_db_column(:country).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:pincode).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:street_address).of_type(:text).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:city).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:state).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:nickname).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:landmark).of_type(:string) }
  end

  context 'ActiveRecord Associations' do
    it { expect(address).to belong_to(:user) }
  end
end
