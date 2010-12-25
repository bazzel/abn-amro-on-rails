require 'spec_helper'

describe Expense do
  describe "indices" do
    it { should have_index(:upload_detail_id) }
    it { should have_index(:bank_account_id) }
    it { should have_index(:creditor_id) }
    it { should have_index(:category_id) }
  end

  describe 'associations' do
    it { should belong_to(:upload_detail) }
    it { should belong_to(:bank_account) }
    it { should belong_to(:creditor) }
    it { should belong_to(:category) }
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

  describe ".creditor_name" do
    before(:each) do
      @expense = Factory.build(:expense, :bank_account => nil)
    end

    it "assigns creditor if name can be found" do
      Factory(:creditor, :name => "CZ")
      lambda {
        @expense.creditor_name = "CZ"
      }.should_not change(Creditor, :count)

    end

    it "creates creditor if name cannot be found" do
      lambda {
        @expense.creditor_name = "CZ"
      }.should change(Creditor, :count).by(1)
    end
  end
end


