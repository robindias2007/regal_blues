require "rails_helper"

RSpec.describe ConfigVariablesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/config_variables").to route_to("config_variables#index")
    end

    it "routes to #new" do
      expect(:get => "/config_variables/new").to route_to("config_variables#new")
    end

    it "routes to #show" do
      expect(:get => "/config_variables/1").to route_to("config_variables#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/config_variables/1/edit").to route_to("config_variables#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/config_variables").to route_to("config_variables#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/config_variables/1").to route_to("config_variables#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/config_variables/1").to route_to("config_variables#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/config_variables/1").to route_to("config_variables#destroy", :id => "1")
    end

  end
end
