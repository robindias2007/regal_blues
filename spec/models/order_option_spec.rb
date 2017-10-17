# frozen_string_literal: true

describe OrderOption, type: :model do
  it 'has a valid factory' do
    expect(create(:order_option)).to be_valid
  end
end
