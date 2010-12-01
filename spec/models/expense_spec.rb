require 'spec_helper'

describe Expense do
  describe 'associations' do
    it { should belong_to(:upload_detail) }
  end
  
  describe '#upload' do
    it 'returns the upload attribute from upload_detail' do
      upload = mock_model(Upload)
      upload_detail = mock_model(UploadDetail, :upload => upload)
      expense = Factory.build(:expense)
      expense.stub(:upload_detail).and_return(upload_detail)
      expense.stub(:prev)
      expense.save

      expense.upload.should eql(upload)
    end
  end
  
  describe "#prev" do
    
  end
  
  describe "#balance" do
    it "calculates balance" do
      upload = Factory(:upload)
      
      upload.expenses[0].balance.should eql(434077)
      upload.expenses[1].balance.should eql(431678)
      upload.expenses[2].balance.should eql(428923)
    end
  end
end


