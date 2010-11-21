require 'spec_helper'

describe "uploads/new.html.haml" do
  before(:each) do
    assign(:upload, stub_model(Upload).as_new_record)
  end

  it "renders new upload form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => uploads_path, :method => "post" do
    end
  end
end
