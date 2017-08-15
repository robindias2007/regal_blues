# frozen_string_literal: true

describe DesignerCategorization, type: :model do
  it 'has a valid factory' do
    expect(create(:designer_categorization)).to be_valid
  end

  let(:designer_categorization) { create :designer_categorization }

  context 'ActiveRecord Associations' do
    it { expect(designer_categorization).to belong_to(:designer) }
    it { expect(designer_categorization).to belong_to(:sub_category) }
  end
end
