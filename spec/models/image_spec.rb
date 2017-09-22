# frozen_string_literal: true

describe Image, type: :model do
  let(:image) { create(:image) }

  it 'has a valid factory' do
    expect(create(:image)).to be_valid
  end

  context 'ActiveModel validations' do
    # Presence Validations
    it { expect(image).to validate_presence_of(:image) }
    it { expect(image).to validate_presence_of(:width) }
    it { expect(image).to validate_presence_of(:height) }
    # Numericality Validations
    it { expect(image).to validate_numericality_of(:width).only_integer }
    it { expect(image).to validate_numericality_of(:height).only_integer }
  end

  context 'ActiveRecord databases' do
    it { expect(image).to have_db_column(:image).of_type(:string).with_options(null: false) }
    it { expect(image).to have_db_column(:width).of_type(:integer).with_options(null: false) }
    it { expect(image).to have_db_column(:height).of_type(:integer).with_options(null: false) }
    it { expect(image).to have_db_column(:imageable_type).of_type(:string) }
    it { expect(image).to have_db_column(:imageable_id).of_type(:uuid) }
  end

  context 'ActiveRecord Associations' do
    it { expect(image).to belong_to(:imageable) }
  end
end
