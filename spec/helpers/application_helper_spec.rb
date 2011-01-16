require 'spec_helper'

describe ApplicationHelper do
  describe "postback_url" do
    # Don't forget to install webrat to use have_selector!
    it "returns hidden field tag if url is not created by controller" do
      @postback_url = 'http://example.com'
      helper.postback_url(:controller => 'comments').should have_selector('input[type="hidden"][name="postback_url"][value="http://example.com"]')
    end

    it "returns nil if called if url is created by controller" do
      @postback_url = 'comments/edit/1'
      helper.postback_url(:controller => 'comments').should be_nil
    end
  end
end
