require 'rails_helper'

RSpec.describe "config_variables/new", type: :view do
  before(:each) do
    assign(:config_variable, ConfigVariable.new(
      :event_name => "MyString",
      :param1 => "MyString",
      :param2 => "MyString",
      :param3 => "MyString",
      :param4 => "MyString"
    ))
  end

  it "renders new config_variable form" do
    render

    assert_select "form[action=?][method=?]", config_variables_path, "post" do

      assert_select "input[name=?]", "config_variable[event_name]"

      assert_select "input[name=?]", "config_variable[param1]"

      assert_select "input[name=?]", "config_variable[param2]"

      assert_select "input[name=?]", "config_variable[param3]"

      assert_select "input[name=?]", "config_variable[param4]"
    end
  end
end
