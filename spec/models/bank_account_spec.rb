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

  describe ".balance" do
    it "return 0 if no expenses" do
      Factory(:bank_account).balance.should eql(0)
    end

    it "returns balance of last expense" do
      upload = Factory(:upload, :tab => upload_file('TXT101204150043.TAB'))

      BankAccount.find_by_account_number('861887719').balance.should eql(2326.16)
    end
  end

  describe ".quotient" do
    it "returns quotient of balance and BankAccount with largest amount" do
      bank_account = Factory.build(:bank_account)
      bank_account.stub(:balance).and_return(BigDecimal.new("100.00"))
      max = Factory.build(:bank_account)
      max.stub(:balance).and_return(BigDecimal.new("200.00"))
      BankAccount.stub(:max).and_return(max)

      bank_account.quotient.should eql(0.5)
    end

    it "returns quotient of balance and BankAccount with smallest amount" do
      bank_account = Factory.build(:bank_account)
      bank_account.stub(:balance).and_return(BigDecimal.new("-100.00"))
      max = Factory.build(:bank_account)
      max.stub(:balance).and_return(BigDecimal.new("-200.00"))
      BankAccount.stub(:max).and_return(max)

      bank_account.quotient.should eql(0.5)
    end

    it "returns positive value for quotient" do
      bank_account = Factory.build(:bank_account)
      bank_account.stub(:balance).and_return(BigDecimal.new("-100.00"))
      max = Factory.build(:bank_account)
      max.stub(:balance).and_return(BigDecimal.new("200.00"))
      BankAccount.stub(:max).and_return(max)

      bank_account.quotient.should eql(0.5)
    end

    it "returns 0 if max. balance is 0" do
      bank_account = Factory.build(:bank_account)
      bank_account.stub(:balance).and_return(BigDecimal.new("0.00"))
      max = Factory.build(:bank_account)
      max.stub(:balance).and_return(BigDecimal.new("0.00"))
      BankAccount.stub(:max).and_return(max)

      bank_account.quotient.should eql(0)
    end
  end

  describe "#max" do
    before(:each) do
      @positive = mock_model(BankAccount, :balance => 100)
      @zero = mock_model(BankAccount, :balance => 0)
      @negative = mock_model(BankAccount, :balance => -100)
    end

    it "returns BankAccount with largest amount" do
      BankAccount.stub(:all).and_return([mock_model(BankAccount, :balance => -50), @positive, @zero])
      BankAccount.max.should eql(@positive)
    end

    it "returns BankAccount with largest negative amount" do
      BankAccount.stub(:all).and_return([@negative, @zero, mock_model(BankAccount, :balance => 50)])
      BankAccount.max.should eql(@negative)
    end
  end
end