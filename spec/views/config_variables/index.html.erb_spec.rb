require 'rails_helper'

RSpec.describe "config_variables/index", type: :view do
  before(:each) do
    assign(:config_variables, [
      ConfigVariable.create!(
        :event_name => "Event Name",
        :param1 => "Param1",
        :param2 => "Param2",
        :param3 => "Param3",
        :param4 => "Param4"
      ),
      ConfigVariable.create!(
        :event_name => "Event Name",
        :param1 => "Param1",
        :param2 => "Param2",
        :param3 => "Param3",
        :param4 => "Param4"
      )
    ])
  end

  it "renders a list of config_variables" do
    render
    assert_select "tr>td", :text => "Event Name".to_s, :count => 2
    assert_select "tr>td", :text => "Param1".to_s, :count => 2
    assert_select "tr>td", :text => "Param2".to_s, :count => 2
    assert_select "tr>td", :text => "Param3".to_s, :count => 2
    assert_select "tr>td", :text => "Param4".to_s, :count => 2
  end
end
