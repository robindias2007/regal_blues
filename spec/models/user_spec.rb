# frozen_string_literal: true

describe User, type: :model do
  let(:user) { create :user }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(user).to validate_presence_of(:full_name) }
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_presence_of(:username) }
    it { expect(user).to validate_presence_of(:gender) }
    it { expect(user).to validate_presence_of(:mobile_number) }
    # Uniqueness Validations
    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:username).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:mobile_number).case_insensitive }
    # Length Validations
    it { expect(user).to validate_length_of(:mobile_number).is_at_least(10).is_at_most(13) }
    it { expect(user).to validate_length_of(:username).is_at_least(4).is_at_most(40) }
    # Format Validations
    it { expect(user).to allow_value('Ramesh Suresh').for(:full_name) }
    it { expect(user).to allow_value('asd@asd.com').for(:email) }
    it { expect(user).not_to allow_value('123').for(:full_name) }
    it { expect(user).not_to allow_value('123Abc').for(:full_name) }
    it { expect(user).not_to allow_value('Abc@ Asd').for(:full_name) }
  end

  context 'ActiveRecord databases' do
    it { expect(user).to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:full_name).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:username).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:mobile_number).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:gender).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:avatar).of_type(:string) }
  end

  context 'ActiveRecord Associations' do
    it { expect(user).to have_many(:user_identities) }
    it { expect(user).to have_many(:requests) }
    it { expect(user).to have_many(:addresses) }
  end

  context 'callbacks' do
    it { expect(user).to callback(:downcase_reqd_attrs).before(:save) }
    it { expect(user).to callback(:generate_confirmation_instructions).before(:create) }
  end
end
