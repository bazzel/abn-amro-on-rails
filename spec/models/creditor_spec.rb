require 'spec_helper'

describe Creditor do
  describe "validation" do
    it { should validate_presence_of(:name, :message => 'This field is required. Please enter a value.') }
    it { Factory(:creditor); should validate_uniqueness_of(:name, :message => 'This name already exists. Please enter another one.')}
  end

  describe 'associations' do
    it { should have_many(:presets, :dependent => :destroy) }
  end

end
