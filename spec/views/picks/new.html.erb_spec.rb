require 'rails_helper'

RSpec.describe "picks/new", type: :view do
  before(:each) do
    assign(:pick, Pick.new(
      :cat_name => "MyString",
      :keywords => "MyString",
      :images => "MyString"
    ))
  end

  it "renders new pick form" do
    render

    assert_select "form[action=?][method=?]", picks_path, "post" do

      assert_select "input[name=?]", "pick[cat_name]"

      assert_select "input[name=?]", "pick[keywords]"

      assert_select "input[name=?]", "pick[images]"
    end
  end
end
