# frozen_string_literal: true

describe ProductInfo, type: :model do
  it 'has a valid factory' do
    expect(create(:product_info)).to be_valid
  end

  let(:product_info) { create :product_info }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(product_info).to validate_presence_of(:color) }
    it { expect(product_info).to validate_presence_of(:fabric) }
    it { expect(product_info).to validate_presence_of(:care) }
    # Length Validations
    it { expect(product_info).to validate_length_of(:fabric).is_at_least(3).is_at_most(160) }
    it { expect(product_info).to validate_length_of(:care).is_at_least(3).is_at_most(160) }
  end

  context 'ActiveRecord databases' do
    it { expect(product_info).to have_db_column(:color).of_type(:string).with_options(null: false) }
    it { expect(product_info).to have_db_column(:fabric).of_type(:text).with_options(null: false) }
    it { expect(product_info).to have_db_column(:care).of_type(:text).with_options(null: false) }
    it { expect(product_info).to have_db_column(:notes).of_type(:text) }
    it { expect(product_info).to have_db_column(:work).of_type(:text) }
  end

  context 'ActiveRecord Associations' do
    it { expect(product_info).to belong_to(:product) }
  end
end
