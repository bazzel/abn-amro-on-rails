class CategoriesChart
  attr_accessor :from, :to

  def initialize(bank_account, options = {})
    @bank_account = bank_account
    self.from = options[:from]
    self.to = options[:to]
  end

  def from=(new_value)
    @from = new_value || @bank_account.expenses.minimum(:transaction_date)
  end

  def to=(new_value)
    @to = new_value || @bank_account.expenses.maximum(:transaction_date)
  end

  # Returns an array with an element for every month between
  # the beginning and end date formatted as '%b. %Y'
  # [
  #   "01-10", "02-10", "03-10",
  #   "04-10", "05-10", "06-10",
  #   "07-10", "08-10", "09-10",
  #   "10-10", "11-10", "12-10"
  # ]
  def x_axis_categories
    @x_axis_categories ||= begin
      @x_axis_categories = x_values.map { |x| Date.parse(x).strftime("%m-%y") }
    end
  end

  def category_names(roots = nil)
    grouped_expenses.map(&(roots ? :main_category : :subcategory)).uniq
  end

  def debits(roots = nil)
    account(false, roots)
  end

  def credits(roots = nil)
    account(true, roots)
  end

  # returns the highest sum of debit or sum of credit value per beginning_of_month
  def y_axis_max
    @y_axis_max ||= begin
      # Use 0 as initial value for every new key.
      credits = Hash.new{|h,k| h[k] = 0 }
      debits = Hash.new{|h,k| h[k] = 0 }

      grouped_expenses.each do |expense|
        credits[expense.beginning_of_month] += expense.credit
        debits[expense.beginning_of_month] += expense.debit
      end

      @y_axis_max = (credits.values + debits.values).max
    end
  end

  private
    def account(credit = true, roots = nil)
      category_names(roots).map do |category_name|
        {
          :name => category_name(category_name),
          :data => data_from_group(grouped_expenses, category_name, roots, credit)
        }
      end
    end

    def category_name(category_name)
      category_name || '-'
    end

    def x_values
      @x_values ||= begin
        x_values = []

        beginning_of_month = Date.new(from.year, from.month)

        while beginning_of_month <= to
          x_values << beginning_of_month.strftime("%Y-%m-%d")
          beginning_of_month >>= 1
        end

        # from.year.upto(to.year) do |year|
        #   from.month.upto(to.month) do |month|
        #     x_values << "#{year}-#{month}-1"
        #   end
        # end

        @x_values = x_values
      end
    end

    def data_from_group(group, category_name, roots = nil, credit = true)
      expenses_for_category = expenses_for_category(group, category_name, roots)

      x_values.map do |beginning_of_month|
        expenses_for_month = expenses_for_month(expenses_for_category, beginning_of_month)
        extract_amount(expenses_for_month, credit)
      end
    end

    def expenses_for_category(group, category_name, roots = nil)
      group.select { |i| (roots ? i.main_category : i.subcategory) == category_name }
    end

    def expenses_for_month(expenses, beginning_of_month)
      expenses.select { |record| record.beginning_of_month == beginning_of_month }
    end

    def extract_amount(expenses, credit = true)
      if expenses.empty?
        0
      else
        expenses.inject(0) { |sum, i| sum + (credit ? i.credit : i.debit)}.round(2).to_f
      end
    end

    def grouped_expenses
      @grouped_expenses ||= begin
        sql = <<-SQL
          SELECT DATE_FORMAT(e.transaction_date, '%Y-%m-01')                  AS beginning_of_month,
                 main_categories.name                                         AS main_category,
                 subcategories.name                                           AS subcategory,
                 SUM(IF(e.transaction_amount > 0, e.transaction_amount, 0))   AS credit,
                 SUM(IF(e.transaction_amount < 0, -e.transaction_amount, 0))  AS debit
          FROM   expenses e
                 LEFT JOIN categories subcategories
                   ON e.category_id = subcategories.id
                 LEFT JOIN categories main_categories
                   ON subcategories.parent_id = main_categories.id
          WHERE  e.bank_account_id = #{@bank_account.id}
          GROUP  BY YEAR(e.transaction_date),
                    MONTH(e.transaction_date),
                    main_categories.name,
                    subcategories.name
          ORDER  BY YEAR(e.transaction_date),
                    MONTH(e.transaction_date);
        SQL

        @grouped_expenses = Expense.find_by_sql(sql)
      end
    end
end