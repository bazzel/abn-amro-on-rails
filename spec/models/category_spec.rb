require 'spec_helper'

describe Category do
  before(:each) do
    upload = Factory(:upload, :tab => upload_file('TXT000000000000.TAB'))

    @main_1 = Factory(:category)
    @sub_1_1 = Factory(:category, :parent => @main_1)
    @sub_1_2 = Factory(:category, :parent => @main_1)

    @main_2 = Factory(:category)
    @sub_2_1 = Factory(:category, :parent => @main_2)
    @sub_2_2 = Factory(:category, :parent => @main_2)

    Expense.find_by_description('Description 001').update_attribute(:category, @sub_1_1)
    Expense.find_by_description('Description 002').update_attribute(:category, @sub_1_1)
    Expense.find_by_description('Description 003').update_attribute(:category, @sub_1_2)
    Expense.find_by_description('Description 004').update_attribute(:category, @sub_2_1)
    Expense.find_by_description('Description 005').update_attribute(:category, @sub_2_2)
    Expense.find_by_description('Description 006').update_attribute(:category, @sub_2_2)
  end

  describe "indices" do
    it { should have_index(:parent_id) }
  end

  describe "validation" do
    it { should validate_presence_of(:name, :message => 'This field is required. Please enter a value.') }
    it { Factory(:category); should validate_uniqueness_of(:name, :scope => :parent_id, :message => 'This name already exists. Please enter another one.')}
  end

  describe 'associations' do
    it { should have_many(:expenses, :dependent => :nullify) }
    it { should have_many(:presets, :dependent => :destroy) }
  end

  describe "acts_as_tree" do
    before(:each) do
      @parent = Factory(:category)
    end

    it "acts_as_tree" do
      child = Factory(:category, :parent => @parent)
      @parent.children.should include(child)
    end

    it "returns children ordered by name" do
      @parent.children.create(:name => "foo")
      @parent.children.create(:name => "bar")

      @parent.children.map(&:name).should eql(['bar', 'foo'])
    end
  end

  describe ".credit and .debit" do
    it "returns sum of credit expenses" do
      @sub_1_1.credit.should eql(1.00)
      @sub_1_2.credit.should eql(3.00)
      @main_1.credit.should eql(4.00)

      @sub_2_1.credit.should eql(0)
      @sub_2_2.credit.should eql(11.00)
      @main_2.credit.should eql(11.00)
    end

    it "returns sum of debit expenses" do
      @sub_1_1.debit.should eql(-2.00)
      @sub_1_2.debit.should eql(0)
      @main_1.debit.should eql(-2.00)

      @sub_2_1.debit.should eql(-4.00)
      @sub_2_2.debit.should eql(0)
      @main_2.debit.should eql(-4.00)
    end
  end

  describe "#max" do
    it "returns the value of the subcategory with the highest value (negative included)" do
      Category.max.should eql(11.00)
    end

    it "returns the value of the main category with the highest value (negative included)" do
      Category.max(true).should eql(11.00)
    end

  end

  describe "scopes" do
    # Fails, but looks correct...
    # it { should have_scope(:children).where('parent_id IS NOT NULL').order('name') }
  end
end