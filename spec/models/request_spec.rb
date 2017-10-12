# frozen_string_literal: true

describe Request, type: :model do
  let(:request) { create :request, user: create(:user), min_budget: 0.01 }

  it 'has a valid factory' do
    expect(create(:request)).to be_valid
  end

  context 'ActiveModel Validations' do
    # Presence Validations
    it { expect(request).to validate_presence_of(:name) }
    it { expect(request).to validate_presence_of(:size) }
    it { expect(request).to validate_presence_of(:max_budget) }
    it { expect(request).to validate_presence_of(:timeline) }
    # Uniqueness Validations
    it { expect(request).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
    # Length Validations
    it { expect(request).to validate_length_of(:name).is_at_least(4).is_at_most(60) }
    # Numericality Validations
    it { expect(request).to validate_numericality_of(:min_budget) }
    it { expect(request).to validate_numericality_of(:max_budget).is_greater_than_or_equal_to(request.min_budget) }
  end

  context 'ActiveRecord Nested Attributes' do
    it { expect(request).to accept_nested_attributes_for(:request_images) }
    it { expect(request).to accept_nested_attributes_for(:request_designers) }
  end

  context 'ActiveRecord Associations' do
    it { expect(request).to belong_to(:user) }
    it { expect(request).to belong_to(:sub_category) }
    it { expect(request).to belong_to(:address) }
    it { expect(request).to have_many(:request_designers) }
    it { expect(request).to have_many(:offers) }
    it { expect(request).to have_many(:request_images) }
  end

  context 'ActiveRecord Databases' do
    it { expect(request).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(request).to have_db_column(:size).of_type(:string).with_options(null: false) }
    it { expect(request).to have_db_column(:min_budget).of_type(:decimal).with_options(null: false) }
    it { expect(request).to have_db_column(:max_budget).of_type(:decimal).with_options(null: false) }
    it { expect(request).to have_db_column(:timeline).of_type(:integer).with_options(null: false) }
    it { expect(request).to have_db_column(:description).of_type(:text) }
  end
end
