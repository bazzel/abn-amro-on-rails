require 'spec_helper'
require 'parsers/tab_parser.rb'

describe Parsers::TabParser do
  def txt_file(file_name)
    File.join(Rails.root, 'spec/fixtures/upload', file_name) 
  end

  describe "#foreach" do

    before(:each) do
      @path = txt_file('TXT101231141500.TAB')
    end

    it "has a foreach method" do
      Parsers::TabParser.should respond_to(:foreach)
    end
    
    it "accepts a path parameter" do
      lambda {
        Parsers::TabParser.foreach
      }.should raise_error(ArgumentError)
    end

    it "yields every line in the file" do
      # Assume TXTyymmddHHMMSS.TAB contains 3 data rows
      block_body = mock('block_body')

      block_body.should_receive(:got_here).exactly(3).times
      
      Parsers::TabParser.foreach(@path) do |row|
        block_body.got_here
      end
    end

    it "yields with an array" do
      Parsers::TabParser.foreach(@path) do |row|
        row.should be_an(Array)
      end
    end

    it "should have x elements in each row" do
      Parsers::TabParser.foreach(@path) do |row|
        row.should have(8).elements
      end
    end

    it "contains bankaccount in 1st. element" do
      Parsers::TabParser.foreach(@path) do |row|
        row[0].should eql('861887719')
      end
    end

    it "contains 'EUR' in 2nd. element" do
      Parsers::TabParser.foreach(@path) do |row|
        row[1].should eql('EUR')
      end
    end

    it "contains date of transaction in 3rd. element" do
      Parsers::TabParser.foreach(@path) do |row|
        [Date.parse('20101229'),
         Date.parse('20101230'),
         Date.parse('20101231')].should include(row[2])
      end
    end

    it "contains start balance in 4th. element" do
      Parsers::TabParser.foreach(@path) do |row|
        row[3].should eql(2366.58)
      end
    end
    it "contains end balance in 5th. element" do
      Parsers::TabParser.foreach(@path) do |row|
        row[4].should eql(0.0)
      end
    end
    it "contains date of interest in 6rd. element" do
      Parsers::TabParser.foreach(@path) do |row|
        [Date.parse('20101229'),
         Date.parse('20101230'),
         Date.parse('20101231')].should include(row[5])
      end
    end
    it "contains amount of transaction in 7rd. element" do
      Parsers::TabParser.foreach(@path) do |row|
        [-23.99, -27.55, -17.62].should include(row[6])
      end
    end

    it "contains description of transaction in 8th. element" do
      Parsers::TabParser.foreach(@path) do |row|
        ['BETAALD  29-12-10 14U46 SX2102   ETOS 7249>TILBURG      PASNR 100',
         'BETAALD  30-12-10 14U43 803706   ALBERT HEIJN 1521>TILBURG                               PASNR 100',
         'BETAALD  31-12-10 14U25 SX2101   ETOS 7249>TILBURG      PASNR 100'].should include(row[7])
      end
    end

    describe '#to_hash' do
      it 'include keys which can be used as attributes' do
        Parsers::TabParser.foreach(@path) do |row|
          row.to_hash.keys.should eql([:bankaccount, 
                :currency, 
                :transaction_date, 
                :opening_balance,
                :ending_balance,
                :interest_date,
                :transaction_amount,
                :description])
        end
      end

      it 'includes the array elements as values in the hash' do
        Parsers::TabParser.foreach(@path) do |row|
          h = row.to_hash
          h[:bankaccount].should eql(row[0])
          h[:currency].should eql(row[1])
          h[:transaction_date].should eql(row[2])
          h[:opening_balance].should eql(row[3])
          h[:ending_balance].should eql(row[4])
          h[:interest_date].should eql(row[5])
          h[:transaction_amount].should eql(row[6])
          h[:description].should eql(row[7])
        end
      end
    end
  end
end
