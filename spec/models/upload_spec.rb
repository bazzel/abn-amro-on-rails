require 'spec_helper'

describe Upload do
  describe "validations" do
    it { Factory(:upload); should validate_uniqueness_of(:xls_file_name) }
    it "allow_values_for" do
      should allow_values_for(:xls_file_name, "XLS123456789012.xls",
                                              "XLS123456789012.XLS")
    end

    it "un-allow_values_for" do
      should_not allow_values_for(:xls_file_name, "invalid.xls",
                                                  "XLS.xls",
                                                  "XLS12345678901.xls",
                                                  "XLS1234567890123.xls")
    end
  end

  describe ".xls" do
    it { should have_attached_file(:xls) }
    # it { should validate_attachment_presence(:xls) }
    # it { should validate_attachment_content_type(:xls).
    #                   allowing('application/excel', 
    #                            # 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    #                            'application/vnd.ms-excel').
    #                   rejecting('application/pdf') }
    it { should validate_attachment_size(:xls).
                      less_than(1.megabytes) }
    
  end
end
