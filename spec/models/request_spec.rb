# frozen_string_literal: true

describe Request, type: :model do
  it 'has a valid factory' do
    expect(create(:request)).to be_valid
  end

  let(:request) { create :request }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(request).to validate_presence_of(:name) }
    it { expect(request).to validate_presence_of(:size) }
    it { expect(request).to validate_presence_of(:min_budget) }
    it { expect(request).to validate_presence_of(:max_budget) }
    it { expect(request).to validate_presence_of(:timeline) }
    # Uniqueness Validations
    it { expect(request).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
    # Length Validations
    it { expect(request).to validate_length_of(:name).is_at_least(4).is_at_most(60) }
  end

  context 'ActiveRecord Associations' do
    it { expect(request).to belong_to(:user) }
    it { expect(request).to belong_to(:sub_category) }
    it { expect(request).to have_many(:request_designers) }
  end

  context 'ActiveRecord databases' do
    it { expect(request).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(request).to have_db_column(:size).of_type(:string).with_options(null: false) }
    it { expect(request).to have_db_column(:min_budget).of_type(:decimal).with_options(null: false) }
    it { expect(request).to have_db_column(:max_budget).of_type(:decimal).with_options(null: false) }
    it { expect(request).to have_db_column(:timeline).of_type(:integer).with_options(null: false) }
    it { expect(request).to have_db_column(:description).of_type(:text) }
  end
end
