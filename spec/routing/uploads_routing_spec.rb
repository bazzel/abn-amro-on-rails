require "spec_helper"

describe UploadsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/uploads" }.should route_to(:controller => "uploads", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/uploads/new" }.should route_to(:controller => "uploads", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/uploads/1" }.should route_to(:controller => "uploads", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/uploads/1/edit" }.should route_to(:controller => "uploads", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/uploads" }.should route_to(:controller => "uploads", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/uploads/1" }.should route_to(:controller => "uploads", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/uploads/1" }.should route_to(:controller => "uploads", :action => "destroy", :id => "1")
    end

  end
end
