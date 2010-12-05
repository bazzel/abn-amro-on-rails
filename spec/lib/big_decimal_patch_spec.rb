require 'spec_helper'

describe BigDecimal do
  describe "#positive?" do
    it "returns true for positive numbers" do
      BigDecimal.new('1.00').positive?.should be_true
    end

    it "returns true for 0" do
      BigDecimal.new('0').positive?.should be_true
    end

    it "returns false for negative numbers" do
      BigDecimal.new('-1.00').positive?.should be_false
    end
  end

  describe "#negative?" do
    it "returns true for negative numbers" do
      BigDecimal.new('-1.00').negative?.should be_true
    end

    it "returns false for 0" do
      BigDecimal.new('0').negative?.should be_false
    end

    it "returns false for positive numbers" do
      BigDecimal.new('1.00').negative?.should be_false
    end
  end
  
  
end
