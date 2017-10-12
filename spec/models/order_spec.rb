# frozen_string_literal: true

describe Order, type: :model do
  let(:order) { create :order }

  it 'has a valid factory' do
    expect(create(:order)).to be_valid
  end

  context 'ActiveRecord Associations' do
    it { expect(order).to belong_to(:offer_quotation) }
    it { expect(order).to belong_to(:designer) }
    it { expect(order).to belong_to(:user) }
  end

  context 'ActiveRecord databases' do
    it { expect(order).to have_db_column(:paid).of_type(:boolean).with_options(null: false, default: false) }
    it { expect(order).to have_db_column(:measurements_given).of_type(:boolean).with_options(null: false, default: false) }
    it { expect(order).to have_db_column(:cancelled).of_type(:boolean).with_options(null: false, default: false) }
  end
end
