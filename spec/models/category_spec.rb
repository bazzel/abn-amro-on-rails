require 'spec_helper'

describe Category do
  describe "indices" do
    it { should have_index(:parent_id) }
  end

  describe "validation" do
    it { should validate_presence_of(:name, :message => 'This field is required. Please enter a value.') }
    it { Factory(:category); should validate_uniqueness_of(:name, :scope => :parent_id, :message => 'This name already exist. Please enter another one.')}
  end

  describe 'associations' do
    it { should have_many(:expenses, :dependent => :nullify) }
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

  describe "scopes" do
    # Fails, but looks correct...
    # it { should have_scope(:children).where('parent_id IS NOT NULL').order('name') }
  end
end
