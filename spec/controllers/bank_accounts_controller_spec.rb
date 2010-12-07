require 'spec_helper'

describe BankAccountsController do

  before(:each) do
    @bank_account = mock_model(BankAccount)
    @bank_accounts = [@bank_account]
  end

  describe "GET /bank_accounts/index" do
    before(:each) do
      BankAccount.stub(:all).and_return(@bank_accounts)
    end
    
    def do_get
      get :index
    end

    it "finds all bank_account" do
      BankAccount.should_receive(:all).and_return(@bank_accounts)
      do_get
    end

    it "assigns the bank_accounts for the view" do
      do_get
      assigns[:bank_accounts].should eql(@bank_accounts)
    end
    
    it "renders the index view" do
      do_get
      response.should render_template("index")
    end
  end
  
  describe "GET /bank_accounts/1/edit" do
    before(:each) do
      BankAccount.stub(:find).and_return(@bank_account)
    end
    
    def do_get
      get :edit, :id => 1
    end

    it "finds the bank_account object for the given id" do
      BankAccount.should_receive(:find).with(1)
      do_get
    end

    it "assigns the bank_account for the view" do
      do_get
      assigns[:bank_account].should eql(@bank_account)
    end

    it "renders new" do
      do_get
      response.should render_template('edit')
    end
  end
  
  describe "PUT bank_accounts/1" do

    before(:each) do
      BankAccount.stub(:find).with(1).and_return(@bank_account)
      @bank_account.stub(:update_attributes).and_return(true)
    end

    def do_put
      put :update, :id => 1, :bank_account => { 'these' => 'params' }
    end

    it "finds the bank_account object for the given id" do
      BankAccount.should_receive(:find).with(1)
      do_put
    end

    it "updates the bank_account" do
      @bank_account.should_receive(:update_attributes).with({ 'these' => 'params' })
      do_put
    end

    it "should assign the object for the view" do
      do_put
      assigns[:bank_account].should eql(@bank_account)
    end

    describe "success" do
      it "sets the flash notice" do
        do_put
        flash[:notice].should eql('Bank Account was successfully updated')
      end

      it "redirects to bank_accounts index" do
        do_put
        response.should redirect_to(bank_accounts_path)
      end
    end

    describe "failure" do
      it "should render edit" do
        @bank_account.stub(:update_attributes).and_return(false)
        do_put
        response.should render_template('edit')
      end
    end
  end
end
