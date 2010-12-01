class AddBalanceToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :balance, :integer
  end

  def self.down
    remove_column :expenses, :balance
  end
end
