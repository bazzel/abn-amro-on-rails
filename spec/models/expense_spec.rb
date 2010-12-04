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

      expense.upload.should eql(upload)
    end
  end
  
  describe "#prev" do
    
  end
  
  describe "#balance" do
    it "calculates balance" do
      upload = Factory(:upload)
      
      upload.expenses[0].balance.to_f.should eql(4340.77)
      upload.expenses[1].balance.to_f.should eql(4316.78)
      upload.expenses[2].balance.to_f.should eql(4289.23)
    end
  end
  
  it "adds to the balance of the same bankaccount"
end


