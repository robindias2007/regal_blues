require 'rails_helper'

RSpec.describe "picks/show", type: :view do
  before(:each) do
    @pick = assign(:pick, Pick.create!(
      :cat_name => "Cat Name",
      :keywords => "Keywords",
      :images => "Images"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Cat Name/)
    expect(rendered).to match(/Keywords/)
    expect(rendered).to match(/Images/)
  end
end
