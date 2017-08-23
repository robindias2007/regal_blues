# frozen_string_literal: true

describe SubCategory, type: :model do
  it 'has a valid factory' do
    expect(create(:sub_category)).to be_valid
  end

  let(:sub_category) { create :sub_category }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(sub_category).to validate_presence_of(:name) }
    it { expect(sub_category).to validate_presence_of(:image) }
    # Uniqueness Validations
    it { expect(sub_category).to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'ActiveRecord Associations' do
    it { expect(sub_category).to belong_to(:category) }
    it { expect(sub_category).to have_many(:designers).through(:designer_categorizations) }
    it { expect(sub_category).to have_many(:products) }
    it { expect(sub_category).to have_many(:requests) }
  end

  context 'ActiveRecord databases' do
    it { expect(sub_category).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(sub_category).to have_db_column(:image).of_type(:string).with_options(null: false) }
  end
end
