class AddBalanceToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :balance, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :expenses, :balance
  end
end
