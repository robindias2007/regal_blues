# frozen_string_literal: true

describe DesignerStoreInfo, type: :model do
  it 'has a valid factory' do
    expect(create(:designer_store_info)).to be_valid
  end

  let(:info) { create :designer_store_info }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(info).to validate_presence_of(:display_name) }
    it { expect(info).to validate_presence_of(:registered_name) }
    it { expect(info).to validate_presence_of(:pincode) }
    it { expect(info).to validate_presence_of(:country) }
    it { expect(info).to validate_presence_of(:state) }
    it { expect(info).to validate_presence_of(:city) }
    it { expect(info).to validate_presence_of(:address_line_1) }
    it { expect(info).to validate_presence_of(:contact_number) }
    it { expect(info).to validate_presence_of(:min_order_price) }
    it { expect(info).to validate_presence_of(:processing_time) }
    # Uniqueness Validations
    it { expect(info).to validate_uniqueness_of(:display_name).case_insensitive }
    it { expect(info).to validate_uniqueness_of(:registered_name).case_insensitive }
    # Length Validations
    it { expect(info).to validate_length_of(:pincode).is_at_least(5).is_at_most(6) }
    # Format Validations
    it { expect(info).to allow_value('123456').for(:pincode) }
    it { expect(info).to allow_value('12345').for(:pincode) }
    it { expect(info).to allow_value('10').for(:processing_time) }
    it { expect(info).not_to allow_value('13asd').for(:pincode) }
    it { expect(info).not_to allow_value('123Abc').for(:pincode) }
    it { expect(info).not_to allow_value('8 weeks').for(:processing_time) }
  end

  context 'ActiveRecord Associations' do
    it { expect(info).to belong_to(:designer) }
  end

  context 'ActiveRecord databases' do
    it { expect(info).to have_db_column(:display_name).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:registered_name).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:pincode).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:country).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:state).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:city).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:address_line_1).of_type(:text).with_options(null: false) }
    it { expect(info).to have_db_column(:address_line_2).of_type(:text) }
    it { expect(info).to have_db_column(:contact_number).of_type(:string).with_options(null: false) }
    it { expect(info).to have_db_column(:min_order_price).of_type(:decimal) }
    it { expect(info).to have_db_column(:processing_time).of_type(:integer) }
  end
end
