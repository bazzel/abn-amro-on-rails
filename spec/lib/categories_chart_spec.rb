require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end

  end
end
require 'spec_helper'

describe CategoriesChart do
  before(:each) do
    @expenses = mock('Expenses', :minimum => Date.parse('2010-01-01'), :maximum => Date.parse('2010-12-31'))
    @bank_account = mock_model(BankAccount, :expenses => @expenses)
    @categories_chart = CategoriesChart.new(@bank_account)
  end

  describe ".from" do
    it "uses earliest date of expenses if not specified" do
      @categories_chart.from.should eql(Date.parse('2010-01-01'))
    end
  end

  describe ".to" do
    it "uses latest date of expenses if not specified" do
      @categories_chart.to.should eql(Date.parse('2010-12-31'))
    end
  end

  describe ".x_axis_categories" do
    it "returns an array" do
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should be_an(Array)
    end

    it "have an element for every month between the beginning and end date" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-1-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-6-30'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql([
        "Jan. 2010", "Feb. 2010", "Mar. 2010",
        "Apr. 2010", "May. 2010", "Jun. 2010"
      ])
    end

    it "does not mess up if start month is greater then end month" do
      @categories_chart.stub(:from).and_return(Date.parse('2010-12-1'))
      @categories_chart.stub(:to).and_return(Date.parse('2011-2-28'))
      @x_axis_categories = @categories_chart.x_axis_categories
      @x_axis_categories.should eql(["Dec. 2010", "Jan. 2011", "Feb. 2011"])
    end
  end

  describe ".category_names" do
    before(:each) do
      grouped_expenses = [
        mock('a', :main_category => 'Foo', :subcategory => 'Baz'),
        mock('b', :main_category => 'Bar', :subcategory => 'Qux'),
        mock('c', :main_category => 'Foo', :subcategory => 'Qux'),
        mock('d', :main_category => 'Bar', :subcategory => 'Baz')
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    it "returns an array with uniq subcategory names" do
      @categories_chart.category_names.should eql(['Baz', 'Qux'])
    end

    it "returns an array with uniq main category names" do
      @categories_chart.category_names(true).should eql(['Foo', 'Bar'])
    end
  end

  describe ".y_axis_max" do
    it "returns the highest value of debit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 50, :credit => 100),
        mock('b', :debit => 60, :credit => 90),
        mock('c', :debit => 70, :credit => 80),
        mock('d', :debit => 80, :credit => 70)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end

    it "returns the highest value of credit multiplied by 1.05" do
      grouped_expenses = [
        mock('a', :debit => 100, :credit => 50),
        mock('b', :debit => 90, :credit => 60),
        mock('c', :debit => 80, :credit => 70),
        mock('d', :debit => 70, :credit => 80)
        ]

      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
      @categories_chart.y_axis_max.should eql(120.0)
    end
  end

  describe ".credits and .debits" do
    before(:each) do
      @categories_chart.stub(:from).and_return(Date.parse('2010-01-01'))
      @categories_chart.stub(:to).and_return(Date.parse('2010-03-31'))
      grouped_expenses = [
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 1.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 10.0, :debit => 2.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-01-01', :credit => 15.0, :debit => 3.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-02-01', :credit => 1.0, :debit => 4.0, :main_category => nil, :subcategory => nil),
        mock(:beginning_of_month => '2010-03-01', :credit => 20.0, :debit => 5.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 6.0, :main_category => 'Foo', :subcategory => 'Baz'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 7.0, :main_category => 'Foo', :subcategory => 'Qux'),
        mock(:beginning_of_month => '2010-03-01', :credit => 30.0, :debit => 8.0, :main_category => 'Foo', :subcategory => 'Qux')
        ]
      @categories_chart.stub(:grouped_expenses).and_return(grouped_expenses)
    end

    describe ".credit" do
      it "returns an array" do
        @categories_chart.credits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(20.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.credits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(50.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.credits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(35.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.credits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(1.0)
      end
    end

    describe ".debit" do
      it "returns an array" do
        @categories_chart.debits.should be_an(Array)
      end

      it "adds up the same subcategories" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][0].should eql(3.0)
      end

      it "fills in the missing months with 0" do
        el = @categories_chart.debits.detect {|e| e[:name] == "Baz"}
        el[:data][1].should eql(0)
        el[:data][2].should eql(11.0)
      end

      it "adds up the same main categories" do
        el = @categories_chart.debits(true).detect {|e| e[:name] == "Foo"}
        el[:data][0].should eql(6.0)
      end

      it "replaces nil with '-'" do
        el = @categories_chart.debits.detect {|e| e[:name] == "-"}
        el[:data][1].should eql(4.0)
      end
    end
  end
end
