require 'spec_helper'

describe CategoriesController do

  before(:each) do
   @category = mock_model(Category)
   @categories = [@category]
   Category.stub(:roots).and_return(@categories)
   Category.stub(:children).and_return(@categories)
   @categories.stub(:paginate).and_return(@categories)
   Category.stub(:find).and_return(@category)
  end

  describe "GET /categories/index" do
    def do_get(options = {})
      get :index, options.symbolize_keys
    end

    it "finds all main categories" do
      Category.should_receive(:roots).and_return(@categories)
      @categories.should_receive(:paginate).with(hash_including(:page => nil, :per_page => 25))
      do_get :roots => true
    end

    it "finds all subcategories" do
      Category.should_receive(:children).and_return(@categories)
      @categories.should_receive(:paginate).with(hash_including(:page => nil, :per_page => 25))
      do_get
    end

    it "assigns the categories for the view" do
      do_get
      assigns[:categories].should eql(@categories)
    end

    it "renders index" do
      do_get
      response.should render_template('index')
    end
  end

  describe "GET /categories/new" do
    before(:each) do
      @category = Category.new
      Category.stub(:new).and_return(@category)
    end

    def do_get
      get :new
    end

    it "should initiate a new category object" do
      Category.should_receive(:new)
      do_get
    end

    it "should assign a new category for the view" do
      do_get
      assigns[:category].should eql(@category)
    end

    it "renders new" do
      do_get
      response.should render_template('new')
    end
  end

  describe "POST /categories" do

    before(:each) do
      Category.stub(:new).and_return(@category)
      @category.stub(:save).and_return(true)
      @category.stub(:parent)
    end

    def do_post(params = {})
      post :create, params.merge(:category => { 'these' => 'params' })
    end

    it "creates a new category" do
      Category.should_receive(:new).with({ 'these' => 'params' })
      do_post
    end

    it "saves the category" do
      @category.should_receive(:save)
      do_post
    end

    it "should assign the category for the view" do
      do_post
      assigns[:category].should eql(@category)
    end

    describe "success" do
      it "should set the flash notice" do
        do_post
        flash[:notice].should eql('Category was successfully created')
      end

      it "should redirect to categories index" do
        do_post
        response.should redirect_to(categories_path(:roots => true))
      end

      it "redirects to postback_url if given" do
        do_post :postback_url => 'http://example.com'
        response.should redirect_to('http://example.com')
      end
    end

    describe "failure" do
      it "should render new" do
        @category.stub(:save).and_return(false)
        do_post
        response.should render_template('new')
      end
    end
  end

  describe "GET /categories/1/edit" do
    def do_get
      get :edit, :id => 1
    end

    it "finds the category for the given id" do
      Category.should_receive(:find).with(1)
      do_get
    end

    it "assigns category for the view" do
      do_get
      assigns[:category].should eql(@category)
    end

    it "renders edit" do
      do_get
      response.should render_template('edit')
    end
  end

  describe "PUT categories/1" do

    before(:each) do
      @category.stub(:update_attributes).and_return(true)
    end

    def do_put
      put :update, :id => 1, :category => { 'these' => 'params' }
    end

    it "finds the category for the given id" do
      Category.should_receive(:find).with(1)
      do_put
    end

    it "updates the category" do
      @category.should_receive(:update_attributes).with({ 'these' => 'params' })
      do_put
    end

    it "should assign the category for the view" do
      do_put
      assigns[:category].should eql(@category)
    end

    describe "success" do
      it "sets the flash notice" do
        do_put
        flash[:notice].should eql('Category was successfully updated')
      end

      it "redirects to categories index" do
        do_put
        response.should redirect_to(categories_path)
      end
    end

    describe "failure" do
      it "should render edit" do
        @category.stub(:update_attributes).and_return(false)
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE /categories/1" do
    before(:each) do
      @category.stub(:parent)
    end

    def do_delete
      delete :destroy, :id => 1
    end

    describe "for javascript enabled" do
      it "finds the category for the given id" do
        Category.should_receive(:find).with(1)
        do_delete
      end

      it "destroys the object" do
        @category.should_receive(:destroy)
        do_delete
      end

      it "redirects to main categories index" do
        do_delete
        response.should redirect_to(categories_path(:roots => true))
      end

      it "redirects to subcategories index" do
        @category.stub(:parent).and_return(true)
        do_delete
        response.should redirect_to(categories_path)
      end
    end
  end

  describe "GET /categories/1" do
    def do_get(params = {})
      get :show, params.merge(:id => 1)
    end

    it "finds the category for the given id" do
      Category.should_receive(:find).with(1)
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
