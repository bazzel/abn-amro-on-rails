class Expense < ActiveRecord::Base
  # == Associations
  belongs_to :upload_detail

  # === Callbacks
  before_save :calculate_balance

  def upload
    upload_detail.upload
  end
  
  def prev
    if new_record?
      upload.expenses.last
    else
      upload.expenses.where("expenses.id < ?", self).last
    end
  end

  private
  def calculate_balance
    if prev
      self.balance = prev.balance + transaction_amount.to_i
    else
      self.balance = opening_balance.to_i + transaction_amount.to_i
    end
  end

end
