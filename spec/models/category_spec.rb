# frozen_string_literal: true

describe Category, type: :model do
  it 'has a valid factory' do
    expect(create(:category)).to be_valid
  end

  let(:category) { create :category }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(category).to validate_presence_of(:name) }
    it { expect(category).to validate_presence_of(:image) }
    # Uniqueness Validations
    it { expect(category).to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'ActiveRecord Associations' do
    it { expect(category).to belong_to(:super_category) }
    it { expect(category).to have_many(:sub_categories) }
  end

  context 'ActiveRecord databases' do
    it { expect(category).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(category).to have_db_column(:image).of_type(:string).with_options(null: false) }
  end
end
