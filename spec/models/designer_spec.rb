# frozen_string_literal: true

describe Designer, type: :model do
  it 'has a valid factory' do
    expect(create(:designer)).to be_valid
  end

  let(:designer) { create :designer }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(designer).to validate_presence_of(:full_name) }
    it { expect(designer).to validate_presence_of(:email) }
    it { expect(designer).to validate_presence_of(:location) }
    it { expect(designer).to validate_presence_of(:mobile_number) }
    # Uniqueness Validations
    it { expect(designer).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(designer).to validate_uniqueness_of(:mobile_number).case_insensitive }
    # Length Validations
    it { expect(designer).to validate_length_of(:mobile_number).is_at_least(11).is_at_most(13) }
    it { expect(designer).to validate_length_of(:full_name).is_at_least(4).is_at_most(60) }
    # Format Validations
    it { expect(designer).to allow_value('Ramesh Suresh').for(:full_name) }
    it { expect(designer).to allow_value('asd@asd.com').for(:email) }
    it { expect(designer).not_to allow_value('123').for(:full_name) }
    it { expect(designer).not_to allow_value('123Abc').for(:full_name) }
    it { expect(designer).not_to allow_value('Abc@ Asd').for(:full_name) }
  end

  context 'ActiveRecord Associations' do
    it { expect(designer).to have_one(:designer_store_info) }
    it { expect(designer).to have_one(:designer_finance_info) }
    it { expect(designer).to have_many(:sub_categories).through(:designer_categorizations) }
    it { expect(designer).to have_many(:products) }
    it { expect(designer).to have_many(:request_designers) }
  end

  context 'ActiveRecord databases' do
    it { expect(designer).to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { expect(designer).to have_db_column(:full_name).of_type(:string).with_options(null: false) }
    it { expect(designer).to have_db_column(:location).of_type(:string).with_options(null: false) }
    it { expect(designer).to have_db_column(:mobile_number).of_type(:string).with_options(null: false) }
    it { expect(designer).to have_db_column(:avatar).of_type(:string) }
    it { expect(designer).to have_db_column(:pin).of_type(:string) }
    it { expect(designer).to have_db_column(:available).of_type(:boolean) }
    it { expect(designer).to have_db_column(:verified).of_type(:boolean) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(designer).to respond_to(:confirmed_at?) }
      it { expect(designer).to respond_to(:friendly_password) }
    end

    context 'executes methods correctly' do
      it '#confirmed? tells if a designer is confirmed or not' do
        user = create :user
        expect(user.confirmed?).to eq false
      end

      it '#friendly_password creates a password using SecureRandom' do
        user = create :user
        expect(user.friendly_password.length).to be 20
      end
    end
  end
end
