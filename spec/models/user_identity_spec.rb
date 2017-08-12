# frozen_string_literal: true

describe UserIdentity, type: :model do
  it 'has a valid factory' do
    expect(create(:user_identity)).to be_valid
  end

  let(:user_identity) { create :user_identity }

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(user_identity).to validate_presence_of(:uid) }
    it { expect(user_identity).to validate_presence_of(:provider) }
    # Uniqueness Validations
    it { expect(user_identity).to validate_uniqueness_of(:uid).case_insensitive }
    it { expect(user_identity).to validate_uniqueness_of(:provider).case_insensitive }
  end

  context 'ActiveRecord databases' do
    it { expect(user_identity).to have_db_column(:uid).of_type(:string).with_options(null: false) }
    it { expect(user_identity).to have_db_column(:provider).of_type(:string).with_options(null: false) }
  end
end
