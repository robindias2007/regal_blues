require 'rails_helper'

RSpec.describe "picks/index", type: :view do
  before(:each) do
    assign(:picks, [
      Pick.create!(
        :cat_name => "Cat Name",
        :keywords => "Keywords",
        :images => "Images"
      ),
      Pick.create!(
        :cat_name => "Cat Name",
        :keywords => "Keywords",
        :images => "Images"
      )
    ])
  end

  it "renders a list of picks" do
    render
    assert_select "tr>td", :text => "Cat Name".to_s, :count => 2
    assert_select "tr>td", :text => "Keywords".to_s, :count => 2
    assert_select "tr>td", :text => "Images".to_s, :count => 2
  end
end
