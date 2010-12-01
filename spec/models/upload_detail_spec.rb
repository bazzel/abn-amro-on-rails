require 'spec_helper'

describe UploadDetail do
  describe "associations" do
    it {should have_many(:expenses, :dependent => :destroy)}
    it {should belong_to(:upload) }
  end
  
  describe "expenses" do
    it "creates an expense object for every upload_detail" do
      lambda {
        Factory(:upload_detail)
      }.should change(Expense, :count).by(1)
    end
    
    it "creates an expense object with attributes copied from upload_detail" do
      upload_detail = Factory(:upload_detail, {
       :bankaccount        => '861887719',
       :transaction_date   => Date.today,
       :opening_balance    => 123.45,
       :ending_balance     => 234.56,
       :transaction_amount => 345.67,
       :description        => 'Lorem ipsum'
      })
      expense = upload_detail.expenses[0]
      
      expense.bankaccount.should eql(upload_detail.bankaccount)
      expense.transaction_date.should eql(upload_detail.transaction_date)
      expense.opening_balance.should eql((upload_detail.opening_balance * 100).to_i)
      expense.ending_balance.should eql((upload_detail.ending_balance * 100).to_i)
      expense.transaction_amount.should eql((upload_detail.transaction_amount * 100).to_i)
      expense.description.should eql(upload_detail.description)
    end
  end
end
