require 'spec_helper'

describe "uploads/index.html.haml" do
  before(:each) do
    assign(:uploads, [
      stub_model(Upload),
      stub_model(Upload)
    ])
  end

  it "renders a list of uploads" do
    render
  end
end
