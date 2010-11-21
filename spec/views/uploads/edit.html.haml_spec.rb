require 'spec_helper'

describe "uploads/edit.html.haml" do
  before(:each) do
    @upload = assign(:upload, stub_model(Upload,
      :new_record? => false
    ))
  end

  it "renders the edit upload form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => upload_path(@upload), :method => "post" do
    end
  end
end
