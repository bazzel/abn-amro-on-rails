class CategoriesChart
  # attr_reader :bank_account

  def initialize(bank_account, options = {})
    @bank_account = bank_account
    @from = options[:from] || @bank_account.expenses.minimum(:transaction_date)
    @to = options[:to] || @bank_account.expenses.maximum(:transaction_date)
  end

  def x_axis_categories
    @x_axis_categories ||= begin
      @x_axis_categories = x_values.map { |x| Date.parse(x).strftime("%b. %Y") }
    end
  end

  def debits(roots = nil)
      category_names(roots).map do |category_name|
        {
          :name => category_name(category_name),
          :data => data_from_group(grouped_expenses, category_name, roots, false)
        }
      end
  end

  def credits(roots = nil)
      category_names(roots).map do |category_name|
        {
          :name => category_name(category_name),
          :data => data_from_group(grouped_expenses, category_name, roots, true)
        }
      end
  end

  def y_axis_max
    @y_axis_max ||= (grouped_expenses.map(&:credit) + grouped_expenses.map(&:debit)).max * 1.05
  end

  private
    def category_name(category_name)
      category_name || '-'
    end

    def category_names(roots = nil)
      if roots
        grouped_expenses.map(&:main_category).uniq
      else
        grouped_expenses.map(&:subcategory).uniq
      end
    end

    def x_values
      @x_values ||= begin
        x_values = []

        @from.year.upto(@to.year) do |year|
          @from.month.upto(@to.month) do |month|
            x_values << "#{year}-#{month}-1"
          end
        end

        @x_values = x_values
      end
    end

    def data_from_group(group, category_name, roots = nil, credit = true)
      c = group.select do |i|
        (roots ? i.main_category : i.subcategory) == category_name
      end

      x_values.map do |x|
        exp = c.select { |cat| cat.beginning_of_month == x }

        if exp.empty?
          0
        else
          exp.inject(0) { |sum, i| sum + (credit ? i.credit : i.debit)}.round(2).to_f
        end
      end
    end

    def grouped_expenses
      @grouped_expenses ||= begin
        sql = <<-SQL
          SELECT CONCAT(YEAR(e.transaction_date), '-', MONTH(e.transaction_date), '-', 1) AS beginning_of_month,
                 main_categories.name                                                     AS main_category,
                 subcategories.name                                                       AS subcategory,
                 SUM(IF(e.transaction_amount > 0, e.transaction_amount, 0))
                 AS credit,
                 SUM(IF(e.transaction_amount < 0, -e.transaction_amount, 0))
                 AS debit
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