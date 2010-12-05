class Expense < ActiveRecord::Base
  # == Associations
  belongs_to :upload_detail

  # === Callbacks
  before_save :calculate_balance

  def upload
    upload_detail.upload
  end
  
  def prev
    expenses = upload.expenses.where('expenses.bankaccount = ?', bankaccount)
    expenses = expenses.where("expenses.id < ?", self) unless new_record?
    
    expenses.order("expenses.id ASC").last
  end

  private
  def calculate_balance
    self.balance = (prev ? prev.balance : opening_balance) + transaction_amount
  end

end
