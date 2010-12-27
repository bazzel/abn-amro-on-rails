require 'spec_helper'

describe CreditorsController do
  before(:each) do
   @creditor = mock_model(Creditor)
   @creditors = [@creditor]
   Creditor.stub(:all).and_return(@creditors)
   @creditors.stub(:all).and_return(@creditors)
   @creditors.stub(:paginate).and_return(@creditors)
   Creditor.stub(:find).and_return(@creditor)
  end

  describe "GET /creditors/index" do
    def do_get
      get :index
    end

    it "finds all creditors" do
      Creditor.should_receive(:all).and_return(@creditors)
      @creditors.should_receive(:paginate).with(hash_including(:page => nil, :per_page => 25))
      do_get
    end

    it "assigns the creditors for the view" do
      do_get
      assigns[:creditors].should eql(@creditors)
    end

    it "renders index" do
      do_get
      response.should render_template('index')
    end
  end

  describe "GET /creditors/new" do
    before(:each) do
      @creditor = Creditor.new
      Creditor.stub(:new).and_return(@creditor)
    end

    def do_get
      get :new
    end

    it "should initiate a new creditor object" do
      Creditor.should_receive(:new)
      do_get
    end

    it "should assign a new creditor for the view" do
      do_get
      assigns[:creditor].should eql(@creditor)
    end

    it "renders new" do
      do_get
      response.should render_template('new')
    end
  end

  describe "POST /creditors" do

    before(:each) do
      Creditor.stub(:new).and_return(@creditor)
      @creditor.stub(:save).and_return(true)
    end

    def do_post(params = {})
      post :create, params.merge(:creditor => { 'these' => 'params' })
    end

    it "creates a new creditor" do
      Creditor.should_receive(:new).with({ 'these' => 'params' })
      do_post
    end

    it "saves the creditor" do
      @creditor.should_receive(:save)
      do_post
    end

    it "should assign the creditor for the view" do
      do_post
      assigns[:creditor].should eql(@creditor)
    end

    describe "success" do
      it "should set the flash notice" do
        do_post
        flash[:notice].should eql('Creditor was successfully created')
      end

      it "should redirect to creditors index" do
        do_post
        response.should redirect_to(creditors_path)
      end
    end

    describe "failure" do
      it "should render new" do
        @creditor.stub(:save).and_return(false)
        do_post
        response.should render_template('new')
      end
    end
  end

  describe "GET /creditors/1/edit" do
    def do_get
      get :edit, :id => 1
    end

    it "finds the creditor for the given id" do
      Creditor.should_receive(:find).with(1)
      do_get
    end

    it "assigns creditor for the view" do
      do_get
      assigns[:creditor].should eql(@creditor)
    end

    it "renders edit" do
      do_get
      response.should render_template('edit')
    end
  end

  describe "PUT creditors/1" do

    before(:each) do
      @creditor.stub(:update_attributes).and_return(true)
    end

    def do_put
      put :update, :id => 1, :creditor => { 'these' => 'params' }
    end

    it "finds the creditor for the given id" do
      Creditor.should_receive(:find).with(1)
      do_put
    end

    it "updates the creditor" do
      @creditor.should_receive(:update_attributes).with({ 'these' => 'params' })
      do_put
    end

    it "should assign the creditor for the view" do
      do_put
      assigns[:creditor].should eql(@creditor)
    end

    describe "success" do
      it "sets the flash notice" do
        do_put
        flash[:notice].should eql('Creditor was successfully updated')
      end

      it "redirects to creditors index" do
        do_put
        response.should redirect_to(creditors_path)
      end
    end

    describe "failure" do
      it "should render edit" do
        @creditor.stub(:update_attributes).and_return(false)
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE /creditors/1" do
    def do_delete
      delete :destroy, :id => 1
    end

    describe "for javascript enabled" do
      it "finds the creditor for the given id" do
        Creditor.should_receive(:find).with(1)
        do_delete
      end

      it "destroys the object" do
        @creditor.should_receive(:destroy)
        do_delete
      end

      it "redirects to creditors index" do
        do_delete
        response.should redirect_to(creditors_path)
      end
    end
  end

  describe "GET /creditors/1" do
    def do_get(params = {})
      get :show, params.merge(:id => 1)
    end

    it "finds the creditor for the given id" do
      Creditor.should_receive(:find).with(1)
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
end
