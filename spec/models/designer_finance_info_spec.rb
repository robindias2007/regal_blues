# frozen_string_literal: true

describe DesignerFinanceInfo, type: :model do
  it 'has a valid factory' do
    expect(create(:designer_finance_info)).to be_valid
  end

  let(:info) { create :designer_finance_info }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(info).to validate_presence_of(:bank_name) }
    it { expect(info).to validate_presence_of(:bank_branch) }
    it { expect(info).to validate_presence_of(:ifsc_code) }
    it { expect(info).to validate_presence_of(:account_number) }
    it { expect(info).to validate_presence_of(:blank_cheque_proof) }
    it { expect(info).to validate_presence_of(:personal_pan_number) }
    it { expect(info).to validate_presence_of(:personal_pan_number_proof) }
    it { expect(info).to validate_presence_of(:business_pan_number) }
    it { expect(info).to validate_presence_of(:business_pan_number_proof) }
    it { expect(info).to validate_presence_of(:tin_number) }
    it { expect(info).to validate_presence_of(:tin_number_proof) }
    it { expect(info).to validate_presence_of(:gstin_number) }
    it { expect(info).to validate_presence_of(:gstin_number_proof) }
    it { expect(info).to validate_presence_of(:business_address_proof) }
    # Uniqueness Validations
    it { expect(info).to validate_uniqueness_of(:account_number).case_insensitive }
    it { expect(info).to validate_uniqueness_of(:business_pan_number).case_insensitive }
    it { expect(info).to validate_uniqueness_of(:personal_pan_number).case_insensitive }
    it { expect(info).to validate_uniqueness_of(:tin_number).case_insensitive }
    it { expect(info).to validate_uniqueness_of(:gstin_number).case_insensitive }
  end

  context 'ActiveRecord Associations' do
    it { expect(info).to belong_to(:designer) }
  end

  context 'ActiveRecord databases' do
    it { expect(info).to have_db_column(:bank_name).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:bank_branch).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:ifsc_code).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:account_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:blank_cheque_proof).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:personal_pan_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:personal_pan_number_proof).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:business_pan_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:business_pan_number_proof).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:tin_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:tin_number_proof).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:gstin_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:gstin_number_proof).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:business_address_proof).of_type(:string).with_options(null: false) }
  end
end
