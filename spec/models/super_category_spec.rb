# frozen_string_literal: true

describe SuperCategory, type: :model do
  it 'has a valid factory' do
    expect(create(:super_category)).to be_valid
  end

  let(:super_category) { create :super_category }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(super_category).to validate_presence_of(:name) }
    it { expect(super_category).to validate_presence_of(:image) }
    # Uniqueness Validations
    it { expect(super_category).to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'ActiveRecord Associations' do
    it { expect(super_category).to have_many(:categories) }
  end

  context 'ActiveRecord databases' do
    it { expect(super_category).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(super_category).to have_db_column(:image).of_type(:string).with_options(null: false) }
  end
end
