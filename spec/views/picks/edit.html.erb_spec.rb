require 'rails_helper'

RSpec.describe "picks/edit", type: :view do
  before(:each) do
    @pick = assign(:pick, Pick.create!(
      :cat_name => "MyString",
      :keywords => "MyString",
      :images => "MyString"
    ))
  end

  it "renders the edit pick form" do
    render

    assert_select "form[action=?][method=?]", pick_path(@pick), "post" do

      assert_select "input[name=?]", "pick[cat_name]"

      assert_select "input[name=?]", "pick[keywords]"

      assert_select "input[name=?]", "pick[images]"
    end
  end
end
