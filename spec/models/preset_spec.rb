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
end
