require 'spec_helper'

describe FilterHelper do
  describe "link_to_filter" do
    before(:each) do
      @bank_account = mock_model(BankAccount, :id => 99)
      @creditor = mock_model(Creditor, :id => 101, :name => 'Foo')
      @url = bank_account_expenses_path(@bank_account)
      @search_attributes = {}
    end

    describe "creditor is not present in current filter" do
      it "outputs an anchor tag" do
        link_to_filter = helper.link_to_filter(@creditor, @url, @search_attributes)

        expected_url = url_for({
          :action => 'index',
          :controller => 'expenses',
          :bank_account_id => @bank_account.id,
          :search => {
            :creditor_id_in => [@creditor.id]
          }
        })

        link_to_filter.should have_selector(:a, :href => expected_url, :content => "Foo")
      end

      it "does not output an anchor tag for removing the filter" do
        link_to_filter = helper.link_to_filter(@creditor, @url, @search_attributes)
        link_to_filter.should_not have_selector(:a, :class => "in_filter")
      end
    end

    describe "creditor is used in filter" do
      it "outputs an anchor tag if creditor is the only filter" do
        @search_attributes = {
          :creditor_id_in => [101]
        }

        link_to_filter = helper.link_to_filter(@creditor, @url, @search_attributes)

        expected_url = url_for({
          :action => 'index',
          :controller => 'expenses',
          :bank_account_id => @bank_account.id,
        })

        link_to_filter.should have_selector(:a, :href => expected_url, :content => "Foo")
        link_to_filter.should have_selector(:a, :class => "in_filter", :content => "Foo")
        link_to_filter.should have_selector(:a, :title => "Remove filter on '#{@creditor.name}'", :content => "Foo")
      end

      it "outputs an anchor tag if creditor is one of the filter" do
        @search_attributes = {
          :creditor_id_in => [101, 789]
        }

        link_to_filter = helper.link_to_filter(@creditor, @url, @search_attributes)

        expected_url = url_for({
          :action => 'index',
          :controller => 'expenses',
          :bank_account_id => @bank_account.id,
          :search => {
            :creditor_id_in => [789]
          }
        })

        link_to_filter.should have_selector(:a, :href => expected_url, :content => "Foo")
        link_to_filter.should have_selector(:a, :class => "in_filter", :content => "Foo")
        link_to_filter.should have_selector(:a, :title => "Remove filter on '#{@creditor.name}'", :content => "Foo")
      end
    end
  end
end
