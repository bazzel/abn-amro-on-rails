require 'spec_helper'
require 'parsers/tab_parser.rb'

describe Parsers::TabParser do
  describe "#foreach" do
    it "has a foreach method" do
      Parsers::TabParser.should respond_to(:foreach)
    end
    
    it "accepts a path parameter" do
      lambda {
        Parsers::TabParser.foreach
      }.should raise_error(ArgumentError)
    end

    it "yields..." do
      # Assume TXTyymmddHHMMSS.TAB contains 3 data rows
      block_body = mock('block_body')
      block_body.should_receive(:got_here).exactly(3).times
      Parsers::TabParser.foreach('path/to/file.tab') do |row|
        block_body.got_here
      end
    end
  end
end
