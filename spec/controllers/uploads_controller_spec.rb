require 'spec_helper'

describe UploadsController do
  login_admin

  def mock_upload(stubs={})
    (@mock_upload ||= mock_model(Upload).as_null_object).tap do |upload|
      upload.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all uploads as @uploads" do
      Upload.stub(:all) { [mock_upload] }
      get :index
      assigns(:uploads).should eq([mock_upload])
    end
  end

  describe "GET show" do
    it "assigns the requested upload as @upload" do
      Upload.stub(:find).with("37") { mock_upload }
      get :show, :id => "37"
      assigns(:upload).should be(mock_upload)
    end
  end

  describe "GET new" do
    it "assigns a new upload as @upload" do
      Upload.stub(:new) { mock_upload }
      get :new
      assigns(:upload).should be(mock_upload)
    end
  end

  describe "GET edit" do
    it "assigns the requested upload as @upload" do
      Upload.stub(:find).with("37") { mock_upload }
      get :edit, :id => "37"
      assigns(:upload).should be(mock_upload)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created upload as @upload" do
        Upload.stub(:new).with({'these' => 'params'}) { mock_upload(:save => true) }
        post :create, :upload => {'these' => 'params'}
        assigns(:upload).should be(mock_upload)
      end

      it "redirects to the created upload" do
        Upload.stub(:new) { mock_upload(:save => true) }
        post :create, :upload => {}
        response.should redirect_to(upload_url(mock_upload))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved upload as @upload" do
        Upload.stub(:new).with({'these' => 'params'}) { mock_upload(:save => false) }
        post :create, :upload => {'these' => 'params'}
        assigns(:upload).should be(mock_upload)
      end

      it "re-renders the 'new' template" do
        Upload.stub(:new) { mock_upload(:save => false) }
        post :create, :upload => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested upload" do
        Upload.should_receive(:find).with("37") { mock_upload }
        mock_upload.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :upload => {'these' => 'params'}
      end

      it "assigns the requested upload as @upload" do
        Upload.stub(:find) { mock_upload(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:upload).should be(mock_upload)
      end

      it "redirects to the upload" do
        Upload.stub(:find) { mock_upload(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(upload_url(mock_upload))
      end
    end

    describe "with invalid params" do
      it "assigns the upload as @upload" do
        Upload.stub(:find) { mock_upload(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:upload).should be(mock_upload)
      end

      it "re-renders the 'edit' template" do
        Upload.stub(:find) { mock_upload(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested upload" do
      Upload.should_receive(:find).with("37") { mock_upload }
      mock_upload.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the uploads list" do
      Upload.stub(:find) { mock_upload }
      delete :destroy, :id => "1"
      response.should redirect_to(uploads_url)
    end
  end

end
