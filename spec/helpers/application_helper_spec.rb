require 'spec_helper'

describe ApplicationHelper do
  describe "postback_url_unless" do
    before(:each) do
      @postback_url = 'http://example.com'
    end

    # Don't forget to install webrat to use have_selector!
    it "returns hidden field tag if url is not created by controller" do
      @controller.stub(:controller_name).and_return('posts')
      helper.postback_url_unless(:controller => 'comments').should have_selector('input[type="hidden"][name="postback_url"][value="http://example.com"]')
    end

    it "returns nil if called if url is created by controller" do
      @controller.stub(:controller_name).and_return('comments')
      helper.postback_url_unless(:controller => 'comments').should be_nil
    end
  end
end
