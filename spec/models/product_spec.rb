# frozen_string_literal: true

describe Product, type: :model do
  let(:product) { create :product }

  it 'has a valid factory' do
    expect(create(:product)).to be_valid
  end

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(product).to validate_presence_of(:name) }
    it { expect(product).to validate_presence_of(:description) }
    it { expect(product).to validate_presence_of(:selling_price) }
    # Uniqueness Validations
    it { expect(product).to validate_uniqueness_of(:name).scoped_to(:designer_id) }
    # Length Validations
    it { expect(product).to validate_length_of(:name).is_at_least(4).is_at_most(100) }
    it { expect(product).to validate_length_of(:description).is_at_least(50).is_at_most(300) }
    # Numericality Validations
    it do
      expect(product).to validate_numericality_of(:selling_price)
        .is_greater_than_or_equal_to(product.designer.designer_store_info.min_order_price)
    end
  end

  context 'ActiveRecord databases' do
    it { expect(product).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(product).to have_db_column(:description).of_type(:text).with_options(null: false) }
    it do
      expect(product).to have_db_column(:selling_price).of_type(:decimal)
                                                       .with_options(null: false, precision: 12, scale: 2, default: 0.0)
    end
    it { expect(product).to have_db_column(:sku).of_type(:string).with_options(null: false) }
    it { expect(product).to have_db_column(:active).of_type(:boolean).with_options(null: false) }
  end

  context 'ActiveRecord Associations' do
    it { expect(product).to belong_to(:sub_category) }
    it { expect(product).to belong_to(:designer) }
    it { expect(product).to have_many(:images) }
  end

  context 'callbacks' do
    it { expect(product).to callback(:generate_sku).before(:save) }
  end
end
