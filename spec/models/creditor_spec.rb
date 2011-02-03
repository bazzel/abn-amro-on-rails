require 'spec_helper'

describe Creditor do
  describe "validation" do
    it { should validate_presence_of(:name, :message => 'This field is required. Please enter a value.') }
    it { Factory(:creditor); should validate_uniqueness_of(:name, :message => 'This name already exists. Please enter another one.')}
  end

  describe 'associations' do
    it { should have_many(:presets, :dependent => :destroy) }
  end

  # prioritized is defined in lib/core_extensions/sortable.rb
  # and included through config/initializers/core_extensions.rb
  describe "#prioritized" do
    before(:each) do
      @creditors = Array.new(10) do |i|
        Factory(:creditor, :id => i+1)
      end
    end

    it "returns the given creditors ordered by the ids in the checked array" do

      priorities = Creditor.prioritized(@creditors, [10,3,1])

      priorities[0].id.should eql(1)
      priorities[1].id.should eql(3)
      priorities[2].id.should eql(10)
    end

    it "returns the given creditors as is when no checked array is provided" do
      Creditor.prioritized(@creditors, nil).should eql(@creditors)
    end
  end
end
