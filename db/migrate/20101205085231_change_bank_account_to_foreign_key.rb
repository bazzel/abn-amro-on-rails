class ChangeBankAccountToForeignKey < ActiveRecord::Migration
  def self.up
    remove_column(:expenses, :bankaccount)
    add_column(:expenses, :bank_account_id, :integer)
  end

  def self.down
    remove_column(:expenses, :bank_acount_id)
    add_column(:expenses, :bankaccount, :string)
  end
end
