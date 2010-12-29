class Expense < ActiveRecord::Base
  # == Associations
  belongs_to :upload_detail
  belongs_to :bank_account
  belongs_to :creditor
  belongs_to :category

  # === Callbacks
  before_save :calculate_balance

  attr_accessor :account_number,
                :creditor_name

  # === Scopes
  scope :credit, where('transaction_amount > 0')
  scope :debit, where('transaction_amount < 0')

  def creditor_name=(name)
    self.creditor = Creditor.find_or_create_by_name(name) unless name.blank?
  end

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

  class << self
    # Returns the balance of the Expense with the largest balance
    # (negative values included!).
    def max_balance
      [maximum(:balance), minimum(:balance).abs].max
    end
  end

end
