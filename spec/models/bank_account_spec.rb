require 'spec_helper'

describe BankAccount do
  describe 'associations' do
    it { should have_many(:expenses) }
  end
  
  describe "validation" do
    it { should validate_presence_of(:account_number, :message => 'This field is required. Please enter a value.') }
    it { Factory(:bank_account); should validate_uniqueness_of(:account_number, :message => 'This account number already exist. Please enter another one.')}
  end
  
  describe ".bank_account=" do
    it "can only be set once" do
      bank_account = Factory.build(:bank_account, :account_number => '861887719')
      bank_account.account_number = '972259171'
      
      bank_account.account_number.should eql('861887719')
    end
  end

  describe ".to_s" do
    before(:each) do
      @bank_account = Factory.build(:bank_account, :account_number => '861887719')
    end
    
    it "returns formatted account_number" do
      "#{@bank_account}".should eql('86.18.87.719')
    end
  end
  
  it "creating bank_acocunts" do
    lambda {
      Factory(:upload, :tab => upload_file('TXT101204150043.TAB'))
    }.should change(BankAccount, :count).by(3)
  end
  
  

end