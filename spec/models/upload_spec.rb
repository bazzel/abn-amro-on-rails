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

  describe "associations" do
    it {should have_many(:upload_details, :dependent => :destroy)}
    it {should have_many(:expenses, :through => :upload_details)}
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
  
  describe ".downloaded_at" do
    it "parse datetime from filename and stores it as downloaded_at" do
      upload = Factory(:upload)
      upload.downloaded_at.should eql(DateTime.parse('20101121 10:04:33'))
    end
  end
  
  describe ".upload_details" do
    it "creates a upload_detail for every line in the TAB file" do
      upload = Factory(:upload)
      upload.should have(110).upload_details
    end
  end
  
  describe "#bank_accounts" do
    it "returns the bank_accounts which have transactions in the uploaded file" do
      upload = Factory(:upload, :tab => upload_file('TXT101204150043.TAB'))

      %w{861887719 808257226 845593013}.each do |account_number|
        upload.bank_accounts.map(&:account_number).should include(account_number)
      end
    end
  end
end
