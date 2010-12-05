require 'spec_helper'

describe BankAccount do
  describe 'associations' do
    it { should have_many(:expenses) }
  end
  
  it "creating bank_acocunts" do
    lambda {
      Factory(:upload, :tab => File.new(File.join(Rails.root, "spec/fixtures/upload", 'TXT101204150043.TAB')))
    }.should change(BankAccount, :count).by(3)
  end
  

end