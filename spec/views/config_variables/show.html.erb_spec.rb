require 'rails_helper'

RSpec.describe "config_variables/show", type: :view do
  before(:each) do
    @config_variable = assign(:config_variable, ConfigVariable.create!(
      :event_name => "Event Name",
      :param1 => "Param1",
      :param2 => "Param2",
      :param3 => "Param3",
      :param4 => "Param4"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Event Name/)
    expect(rendered).to match(/Param1/)
    expect(rendered).to match(/Param2/)
    expect(rendered).to match(/Param3/)
    expect(rendered).to match(/Param4/)
  end
end
