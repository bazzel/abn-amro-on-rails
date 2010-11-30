require 'spec_helper'

describe ExpensesController do
  before(:each) do
   @upload = mock_model(Upload)
   @expenses = [mock_model(Expense)]
   Upload.stub(:find).and_return(@upload)
   @upload.stub(:expenses).and_return(@expenses)
  end
  
  describe "GET /upload/1/expenses/index" do
    def do_get
      get :index, :upload_id => 1
    end
    
    it "finds the upload object for the given upload_id and assigns it for the view" do
      Upload.should_receive(:find).with(1).and_return(@upload)
      do_get
      assigns[:upload].should eql(@upload)
    end
    
    it "assigns the slides for the view" do
      @upload.should_receive(:expenses).and_return(@expenses)
      do_get
      assigns[:expenses].should eql(@expenses)
    end
    
    it "renders index" do
      do_get
      response.should render_template('index')
    end
  end
end
