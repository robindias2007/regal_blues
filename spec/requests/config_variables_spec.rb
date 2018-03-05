require 'rails_helper'

RSpec.describe "ConfigVariables", type: :request do
  describe "GET /config_variables" do
    it "works! (now write some real specs)" do
      get config_variables_path
      expect(response).to have_http_status(200)
    end
  end
end
