require 'spec_helper'

describe ExpensesController do
  before(:each) do
    @upload = mock_model(Upload)
    @bank_account = mock_model(BankAccount, :id => 1)
    @bank_accounts = [@bank_account]
    @expense = mock_model(Expense, :id => 100)
    @expenses = [@expense]
    @expenses.stub(:includes).and_return(@expenses)
    @expenses.stub(:order).and_return(@expenses)
    BankAccount.stub(:find).and_return(@bank_account)
    @bank_account.stub(:expenses).and_return(@expenses)
  end

  describe "GET /bank_accounts/1/expenses/index" do
    before(:each) do
      @categories_chart = mock('CategoriesChart')
      CategoriesChart.stub(:new).and_return(@categories_chart)
    end

    def do_get(params = {})
      get :index, params
    end

    describe "no bank_account_id" do
      it "find first bank account and assigns it for the view" do
        BankAccount.should_receive(:first).and_return(@bank_account)
        do_get
      end
    end

    describe "upload_id" do
      before(:each) do
        Upload.stub(:find).with(1).and_return(@upload)
        @upload.stub(:bank_accounts).and_return(@bank_accounts)
        @expenses.stub(:joins).and_return(@expenses)
        @expenses.stub(:where).and_return(@expenses)
      end

      it "finds first bank_account object for given upload_id and assigns it for the view" do
        Upload.should_receive(:find).with(1).and_return(@upload)
        @upload.should_receive(:bank_accounts).at_least(:once).and_return(@bank_accounts)
        @bank_accounts.should_receive(:first).and_return(@bank_account)

        do_get :upload_id => 1
      end

      it "gets the bank_accounts of the uploaded file and assigns them for the view" do
        @upload.should_receive(:bank_accounts).at_least(:once).and_return(@bank_accounts)
        do_get :upload_id => 1
        assigns[:bank_accounts].should eql(@bank_accounts)
      end

      it "filters the expenses on upload_id so only expenses for the uploaded file are returned" do
        @expenses.should_receive(:joins).with(:upload_detail).and_return(@expenses)
        @expenses.should_receive(:where).with('upload_id = ?', 1).and_return(@expenses)
        do_get :upload_id => 1
      end
    end

    describe "no upload_id" do
      it "gets all the bank_accounts and assigns them for the view" do
        BankAccount.should_receive(:all).and_return(@bank_accounts)
        do_get :bank_account_id => 1
        assigns[:bank_accounts].should eql(@bank_accounts)
      end

      it "assigns the expenses for the view" do
        @bank_account.should_receive(:expenses).and_return(@expenses)
        do_get :bank_account_id => 1
        assigns[:expenses].should eql(@expenses)
      end
    end

    it "finds the bank_account object for the given bank_account_id and assigns it for the view" do
      BankAccount.should_receive(:find).with(1).and_return(@bank_account)
      do_get :bank_account_id => 1
      assigns[:bank_account].should eql(@bank_account)
    end

    it "includes bank_account for performance improvement" do
      @expenses.should_receive(:includes).with(:bank_account).and_return(@expenses)
      do_get :bank_account_id => 1
    end

    it "orders on created_at descending" do
      @expenses.should_receive(:order).with('expenses.transaction_date DESC').and_return(@expenses)
      do_get :bank_account_id => 1
    end

    it "renders index" do
      do_get :bank_account_id => 1
      response.should render_template('index')
    end

    it "paginates the expenses" do
      @expenses.should_receive(:paginate).with(hash_including(:page, :per_page))
      do_get :bank_account_id => 1
    end

    it "instantiates a new CategoriesChart object and assigns it to the view" do
      CategoriesChart.should_receive(:new).and_return(@categories_chart)
      do_get :bank_account_id => 1
      assigns[:categories_chart].should eql(@categories_chart)
    end

  end

  describe "GET /bank_accounts/1/expenses/100/edit" do
    before(:each) do
      @expenses.stub(:find).and_return(@expense)
    end

    def do_get
      get :edit, :bank_account_id => 1, :id => 100
    end

    it "finds the bank_account object for the given bank_account_id and assigns it for the view" do
      BankAccount.should_receive(:find).with(1).and_return(@bank_account)
      do_get
      assigns[:bank_account].should eql(@bank_account)
    end

    it "finds the expense object for the given id and assigns it for the view" do
      @bank_account.expenses.should_receive(:find).with(100).and_return(@expense)
      do_get
      assigns[:expense].should eql(@expense)
    end

    it "renders edit" do
      do_get
      response.should render_template('edit')
    end

    it "assigns path to expense edit to postback_url" do
      do_get
      assigns[:pass_through][:postback_url].should eql(edit_bank_account_expense_path(@bank_account, @expense))
    end

    it "assigns new category to the view" do
      category = mock_model(Category)
      Category.stub(:new).and_return(category)
      do_get
      assigns[:category].should eql(category)
    end
  end

  describe "PUT /bank_accounts/1/expense/100" do
    before(:each) do
      @expenses.stub(:find).and_return(@expense)
      @expense.stub(:update_attributes).and_return(true)
    end

    def do_put
      put :update, :bank_account_id => 1, :id => 100, :expense => { 'these' => 'params' }
    end

    it "finds the bank_account object for the given bank_account_id and assigns it for the view" do
      BankAccount.should_receive(:find).with(1).and_return(@bank_account)
      do_put
      assigns[:bank_account].should eql(@bank_account)
    end

    it "finds the expense object for the given id and assigns it for the view" do
      @bank_account.expenses.should_receive(:find).with(100).and_return(@expense)
      do_put
      assigns[:expense].should eql(@expense)
    end

    it "updates the expense" do
      @expense.should_receive(:update_attributes).with({ 'these' => 'params' })
      do_put
    end

    describe "success" do
      it "sets the flash notice" do
        do_put
        flash[:notice].should eql('Expense was successfully updated')
      end

      it "redirects to expenses index" do
        do_put
        response.should redirect_to(bank_account_expenses_path(@bank_account))
      end
    end

  end

  describe "PUT /bank_accounts/1/expense/presets" do

    before(:each) do
      @expenses.stub(:find).and_return(@expenses)
      Preset.stub(:apply).and_return(99)
    end

    def do_put(options = {})
      options = {
        :bank_account_id => 1
      }.merge(options)

      put :presets, options
    end

    it "redirects to expenses index" do
      do_put(:expense_ids => [100, 101])
      response.should redirect_to(bank_account_expenses_path(@bank_account))
    end

    it "sets the flash notice for one expense" do
      Preset.stub(:apply).and_return(1)
      do_put(:expense_ids => [100])
      flash[:notice].should eql('Presets have been applied to 1 expense')
    end

    it "sets the flash notice for two expenses" do
      Preset.stub(:apply).and_return(2)
      do_put(:expense_ids => [100, 101])
      flash[:notice].should eql('Presets have been applied to 2 expenses')
    end

    it "finds all expenses for given ids" do
      @expenses.should_receive(:find).with([100, 101])
      do_put(:expense_ids => [100, 101])
    end

    it "calls apply on Preset and returns number of applied presets" do
      Preset.should_receive(:apply_to).with(@expenses)
      do_put(:expense_ids => [100, 101])
    end

    it "sets the flash error if no ids are given" do
      do_put
      flash[:alert].should eql('Please select one or more expenses and try again.')
    end
  end
end
