require 'spec_helper'

describe Upload do
  describe ".xls" do
    it { should have_attached_file(:xls) }
    it { should validate_attachment_presence(:xls) }
    it { should validate_attachment_content_type(:xls).
                      allowing('application/excel', 
                               # 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                               'application/vnd.ms-excel').
                      rejecting('application/pdf') }
    it { should validate_attachment_size(:xls).
                      less_than(1.megabytes) }
    
  end
end
