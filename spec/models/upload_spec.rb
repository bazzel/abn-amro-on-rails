require 'spec_helper'

describe Upload do
  describe "validations" do
    it { Factory(:upload); should validate_uniqueness_of(:tab_file_name) }
    it "allow_values_for" do
      should allow_values_for(:tab_file_name, "TXT123456789012.tab",
                                              "TXT123456789012.TAB")
    end

    it "un-allow_values_for" do
      should_not allow_values_for(:tab_file_name, "invalid.tab",
                                                  "TXT.tab",
                                                  "TXT12345678901.tab",
                                                  "TXT1234567890123.tab")
    end
  end

  describe ".tab" do
    it { should have_attached_file(:tab) }
    # it { should validate_attachment_presence(:tab) }
    # it { should validate_attachment_content_type(:tab).
    #                   allowing('text/plain').
    #                   rejecting('application/pdf') }
    it { should validate_attachment_size(:tab).
                      less_than(1.megabytes) }
    
  end
end
