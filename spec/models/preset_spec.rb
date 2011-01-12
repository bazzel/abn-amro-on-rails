require 'spec_helper'

describe Preset do
  describe "validation" do
    it { should validate_presence_of(:keyphrase, :message => 'This field is required. Please enter a value.') }
    it { should validate_presence_of(:creditor, :message => 'This field is required. Please enter a value.') }
    it { should validate_presence_of(:category, :message => 'This field is required. Please enter a value.') }
    it { Factory(:preset); should validate_uniqueness_of(:keyphrase, :message => 'This keyphrase already exists. Please enter another one.')}
  end

  describe 'associations' do
    it { should belong_to(:creditor) }
    it { should belong_to(:category) }
  end

  describe ".creditor_name" do
    before(:each) do
      @preset = Factory.build(:preset)
    end

    it "assigns creditor if name can be found" do
      Factory(:creditor, :name => "CZ")
      lambda {
        @preset.creditor_name = "CZ"
      }.should_not change(Creditor, :count)

    end

    it "creates creditor if name cannot be found" do
      lambda {
        @preset.creditor_name = "CZ"
      }.should change(Creditor, :count).by(1)
    end
  end

  describe "#apply_to" do
    before(:each) do
      upload = Factory(:upload, :tab => upload_file('TXT101121100433.TAB'))
      Factory(:preset, :keyphrase => 'ALBERT HEIJN 1521>TILBURG') # 11
      Factory(:preset, :keyphrase => 'KABISA B.V.') # 3
      Factory(:preset, :keyphrase => 'CZ') # 4
      Factory(:preset, :keyphrase => 'Not existing') # 0
    end

    it "returns number of applied presets" do
      Preset.apply_to(Expense.all).should eql(18)
    end

    it "calls Expense.update_all every time a set of expenses are found" do
      Expense.should_receive(:update_all).exactly(3).times
      Preset.apply_to(Expense.all)
    end

    it "case sensitive (or not?)"
    it "does what with whitespaces?"
    it "has a preferred order and start with the longest keyphrase?"
  end

  describe "#apply_for" do
    before(:each) do
      upload = Factory(:upload, :tab => upload_file('TXT101121100433.TAB'))
      Factory(:preset, :keyphrase => 'ALBERT HEIJN 1521>TILBURG') # 11
      Factory(:preset, :keyphrase => 'KABISA B.V.') # 3
      Factory(:preset, :keyphrase => 'CZ') # 4
      Factory(:preset, :keyphrase => 'Not existing') # 0
    end

    it "returns number of applied presets" do
      Preset.apply_for(Preset.all).should eql(18)
    end

    it "calls Expense.update_all every time a set of expenses are found" do
      Expense.should_receive(:update_all).exactly(3).times
      Preset.apply_for(Preset.all)
    end

    it "case sensitive (or not?)"
    it "does what with whitespaces?"
    it "has a preferred order and start with the longest keyphrase?"
  end
end
