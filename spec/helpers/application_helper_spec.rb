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

  describe "must_be_a_sidebar?" do
    it "return false if no @postback_url is set" do
      helper.must_be_a_sidebar?.should be_false
    end

    it "returns false if postback_url matches current controller" do
      @postback_url = 'comments/edit/1'
      helper.stub(:controller_name).and_return('comments')
      helper.must_be_a_sidebar?.should be_false
    end

    it "returns true if postback_url does not match given controller" do
      @postback_url = 'comments/edit/1'
      helper.must_be_a_sidebar?(:controller => 'expenses').should be_true
    end

    it "returns true if postback_url does not match current controller" do
      @postback_url = 'comments/edit/1'
      helper.stub(:controller_name).and_return('expenses')
      helper.must_be_a_sidebar?.should be_true
    end
  end

  describe "li_active_unless" do
    it "returns an li wrapped around the content" do
      helper.li_active_unless("Foo").should have_selector(:li, :content => "Foo")
    end

    describe ".active CSS" do
      it "returns an li with class_name 'active' if current controller matches given controller" do
        helper.stub(:controller_name).and_return('comments')
        helper.li_active_unless("Foo", :controller => 'comments').should have_selector('li.active')
      end

      it "returns an li with class_name 'active' if given controller matches postback_url" do
        helper.stub(:params).and_return(:postback_url => 'comments/edit/1')
        helper.li_active_unless("Foo", :controller => 'comments').should have_selector('li.active')
      end

      it "returns an li with class_name 'active' if given controller matches the child part of a nested route in the postback_url" do
        helper.stub(:params).and_return(:postback_url => 'bank_accounts/1/expenses/100/edit')
        helper.li_active_unless("Foo", :controller => 'expenses').should have_selector('li.active')
      end

      it "returns an li with class_name 'active' even given controller does not match current controller" do
        helper.stub(:controller_name).and_return('comments')
        helper.stub(:params).and_return(:postback_url => 'bank_accounts/1/expenses/100/edit')
        helper.li_active_unless("Foo", :controller => 'expenses').should have_selector('li.active')
      end
    end

    describe "no .active CSS" do
      it "returns an li without class_name 'active' if given controller matches the parent part of a nested route in the postback_url" do
        helper.stub(:params).and_return(:postback_url => 'bank_accounts/1/expenses/100/edit')
        helper.li_active_unless("Foo", :controller => 'bank_account').should_not have_selector('li.active')
      end

      it "returns an li without class_name 'active' if given controller differs from current controller" do
        helper.stub(:controller_name).and_return('categories')
        helper.li_active_unless("Foo", :controller => 'comments').should_not have_selector('li.active')
      end
    end
  end
end
