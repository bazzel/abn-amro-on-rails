class Expense < ActiveRecord::Base
  # == Associations
  belongs_to :upload_detail
  belongs_to :bank_account
  belongs_to :creditor

  # === Callbacks
  before_save :calculate_balance

  attr_accessor :account_number
  
  def upload
    upload_detail.upload
  end
  
  # Returns an array of expenses which 
  # belong to the same upload as <tt>self</tt>.
  def siblings
    upload.expenses
  end
  
  def prev
    expenses = siblings.includes(:bank_account).where('bank_accounts.account_number = ?', account_number)
    expenses = expenses.where("expenses.id < ?", self) unless new_record?
    
    expenses.order("expenses.id ASC").last
  end

  def account_number
    @account_number ||= bank_account.account_number
  end
  
  def account_number=(new_account_number)
    @account_number = new_account_number
    self.bank_account = BankAccount.find_or_create_by_account_number(new_account_number)
  end
  
  private
  def calculate_balance
    self.balance = (prev ? prev.balance : opening_balance) + transaction_amount
  end

end
