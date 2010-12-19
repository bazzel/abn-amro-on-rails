class AddCreditorIdToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :creditor_id, :integer
  end

  def self.down
    remove_column :expenses, :creditor_id
  end
end
