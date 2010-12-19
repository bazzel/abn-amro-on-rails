require 'spec_helper'

describe Expense do
  describe 'associations' do
    it { should belong_to(:upload_detail) }
    it { should belong_to(:bank_account) }
    it { should belong_to(:creditor) }
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
  
  describe "#balance" do
    it "calculates balance" do
      upload = Factory(:upload, :tab => upload_file('TXT101204150043.TAB'))
      
      upload.expenses[0].balance.to_f.should eql(2493.55)
      upload.expenses[1].balance.to_f.should eql(2378.55)
      upload.expenses[2].balance.to_f.should eql(2326.16)

      upload.expenses[3].balance.to_f.should eql(73007.45)
      upload.expenses[4].balance.to_f.should eql(76007.45)

      upload.expenses[5].balance.to_f.should eql(351.21)
      upload.expenses[6].balance.to_f.should eql(361.21)
    end
  end
  
  describe "#account_number" do
    it "creates bank_account if account_number is not recognized" do
      expense = Factory.build(:expense, :bank_account => nil)
      expense.account_number = '861887719'
      
      expense.bank_account.account_number.should eql('861887719')
    end
  end
  
end


