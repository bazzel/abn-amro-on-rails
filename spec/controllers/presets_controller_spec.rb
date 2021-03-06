require 'spec_helper'

describe PresetsController do
  login_admin

  before(:each) do
   @preset = mock_model(Preset)
   @presets = [@preset]
   Preset.stub(:all).and_return(@presets)
   # @creditors.stub(:all).and_return(@creditors)
   @presets.stub(:paginate).and_return(@presets)
   Preset.stub(:find).and_return(@preset)
   @category = mock_model(Category)
  end

  describe "GET /presets/index" do
    def do_get
      get :index
    end

    it "paginates the presets" do
      Preset.should_receive(:all).and_return(@presets)
      @presets.should_receive(:paginate).with(hash_including(:page => nil, :per_page => 25))
      do_get
    end

    it "assigns the presets for the view" do
      do_get
      assigns[:presets].should eql(@presets)
    end

    it "renders index" do
      do_get
      response.should render_template('index')
    end
  end

  describe "GET /presets/new" do
    before(:each) do
      @preset = Preset.new
      Preset.stub(:new).and_return(@preset)
    end

    def do_get
      get :new
    end

    it "should initiate a new preset object" do
      Preset.should_receive(:new)
      do_get
    end

    it "should assign a new preset for the view" do
      do_get
      assigns[:preset].should eql(@preset)
    end

    it "renders new" do
      do_get
      response.should render_template('new')
    end

    it "assigns path to preset new to postback_url" do
      do_get
      assigns[:postback_url].should eql(new_preset_path)
    end

    it "assigns new category to the view" do
      Category.stub(:new).and_return(@category)
      do_get
      assigns[:category].should eql(@category)
    end
  end

  describe "POST /presets" do

    before(:each) do
      Preset.stub(:new).and_return(@preset)
      @preset.stub(:save).and_return(true)
    end

    def do_post(params = {})
      post :create, params.merge(:preset => { 'these' => 'params' })
    end

    it "creates a new preset" do
      Preset.should_receive(:new).with({ 'these' => 'params' })
      do_post
    end

    it "saves the preset" do
      @preset.should_receive(:save)
      do_post
    end

    it "should assign the preset for the view" do
      do_post
      assigns[:preset].should eql(@preset)
    end

    describe "success" do
      describe "submitted from preset view" do
        it "should set the flash notice" do
          do_post
          flash[:notice].should eql('Preset was successfully created')
        end

        it "should redirect to presets index" do
          do_post
          response.should redirect_to(presets_path)
        end
      end

      describe "submitted from sidebar" do
        it "redirects to postback_url if given" do
          do_post :postback_url => 'http://example.com'
          response.should redirect_to('http://example.com')
        end
      end
    end

    describe "failure" do
      before(:each) do
        @preset.stub(:save).and_return(false)
      end

      describe "submitted from preset view" do
        it "renders new" do
          do_post
          response.should render_template('new')
        end

        it "assigns path to preset new to postback_url" do
          do_post
          assigns[:postback_url].should eql(new_preset_path)
        end

        it "assigns new category to the view" do
          Category.stub(:new).and_return(@category)
          do_post
          assigns[:category].should eql(@category)
        end
      end

      describe "submitted from expense sidebar" do
        before(:each) do
          @bank_account = mock_model(BankAccount, :id => 1)
          @expense = mock_model(Expense, :id => 100)
          @postback_url = edit_bank_account_expense_path(@bank_account, @expense) #'/bank_accounts/1/expenses/664/edit'
          Expense.stub(:find).and_return(@expense)
          BankAccount.stub(:find).and_return(@bank_account)
        end

        it "finds expense with id extracted from postback_url" do
          Expense.should_receive(:find).with("100")
          do_post :postback_url => @postback_url
        end

        it "finds bankaccount with id extracted from postback_url" do
          BankAccount.should_receive(:find).with("1")
          do_post :postback_url => @postback_url
        end

        it "re-assigns postback_url" do
          do_post :postback_url => @postback_url
          assigns[:postback_url].should eql(@postback_url)
        end

        it "assigns new category to the view" do
          Category.stub(:new).and_return(@category)
          do_post :postback_url => @postback_url
          assigns[:category].should eql(@category)
        end

        it "renders template to a path extracted from postback_url" do
          do_post :postback_url => @postback_url
          response.should render_template('expenses/edit')
        end
      end
    end
  end

  describe "GET /presets/1/edit" do
    def do_get
      get :edit, :id => 1
    end

    it "finds the preset for the given id" do
      Preset.should_receive(:find).with(1)
      do_get
    end

    it "assigns preset for the view" do
      do_get
      assigns[:preset].should eql(@preset)
    end

    it "renders edit" do
      do_get
      response.should render_template('edit')
    end

    it "assigns path to preset edit to postback_url" do
      do_get
      assigns[:postback_url].should eql(edit_preset_path(@preset))
    end

    it "assigns new category to the view" do
      Category.stub(:new).and_return(@category)
      do_get
      assigns[:category].should eql(@category)
    end

  end

  describe "PUT presets/1" do

    before(:each) do
      @preset.stub(:update_attributes).and_return(true)
    end

    def do_put
      put :update, :id => 1, :preset => { 'these' => 'params' }
    end

    it "finds the preset for the given id" do
      Preset.should_receive(:find).with(1)
      do_put
    end

    it "updates the preset" do
      @preset.should_receive(:update_attributes).with({ 'these' => 'params' })
      do_put
    end

    it "should assign the preset for the view" do
      do_put
      assigns[:preset].should eql(@preset)
    end

    describe "success" do
      it "sets the flash notice" do
        do_put
        flash[:notice].should eql('Preset was successfully updated')
      end

      it "redirects to presets index" do
        do_put
        response.should redirect_to(presets_path)
      end
    end

    describe "failure" do
      before(:each) do
        @preset.stub(:update_attributes).and_return(false)
      end

      it "should render edit" do
        do_put
        response.should render_template('edit')
      end

      it "assigns path to preset edit to postback_url" do
        do_put
        assigns[:postback_url].should eql(edit_preset_path(@preset))
      end

      it "assigns new category to the view" do
        Category.stub(:new).and_return(@category)
        do_put
        assigns[:category].should eql(@category)
      end

    end
  end

  describe "DELETE /presets/1" do
    def do_delete
      delete :destroy, :id => 1
    end

    describe "for javascript enabled" do
      it "finds the preset for the given id" do
        Preset.should_receive(:find).with(1)
        do_delete
      end

      it "destroys the object" do
        @preset.should_receive(:destroy)
        do_delete
      end

      it "redirects to presets index" do
        do_delete
        response.should redirect_to(presets_path)
      end
    end
  end

  describe "GET /presets/1" do
    def do_get(params = {})
      get :show, params.merge(:id => 1)
    end

    it "finds the preset for the given id" do
      Preset.should_receive(:find).with(1)
      do_get
    end

    describe "destroy with javascript disabled" do
      it "renders confirm_destroy" do
        do_get :destroy => true
        response.should render_template('confirm_destroy')
      end
    end

    describe "show" do
      it "renders show" do
        do_get
        response.should render_template('show')
      end
    end
  end

  describe "PUT /presets/apply_multiple" do

    before(:each) do
      Preset.stub(:find).and_return(@presets)
      Preset.stub(:apply_for).and_return(99)
    end

    def do_put(options = {})
      put :apply_multiple, options
    end

    it "redirects to expenses index" do
      do_put(:preset_ids => [100, 101])
      response.should redirect_to(presets_path)
    end

    it "sets the flash notice for one preset" do
      Preset.stub(:apply_for).and_return(1)
      do_put(:preset_ids => [100])
      flash[:notice].should eql('Presets have been applied to 1 expense')
    end

    it "sets the flash notice for two presets" do
      Preset.stub(:apply_for).and_return(2)
      do_put(:preset_ids => [100, 101])
      flash[:notice].should eql('Presets have been applied to 2 expenses')
    end

    it "finds all expenses for given ids" do
      Preset.should_receive(:find).with([100, 101])
      do_put(:preset_ids => [100, 101])
    end

    it "calls apply on Preset and returns number of applied presets" do
      Preset.should_receive(:apply_for).with(@presets)
      do_put(:preset_ids => [100, 101])
    end

    it "sets the flash error if no ids are given" do
      do_put
      flash[:alert].should eql('Please select one or more presets and try again.')
    end
  end

end
