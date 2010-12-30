module ExpensesChartHelper
  def expenses_chart_series(expenses)
    expenses_by_day = expenses.group(:transaction_date).
      select('transaction_date, AVG(balance) AS avg_balance')
    balance = 0

    (expenses.minimum(:transaction_date)..expenses.maximum(:transaction_date)).map do |date|
      expense = expenses_by_day.detect { |expense| expense.transaction_date.to_date == date }

      if expense
        balance = expense.avg_balance.round(2).to_f
      end

      balance
    end
  end
end