class UploadDetail < ActiveRecord::Base
  # === Associations
  has_many :expenses, :dependent => :destroy

  # === Callbacks
  before_create :build_expense
  
  private
  def build_expense
    expenses.build({
     :bankaccount        => bankaccount,
     :transaction_date   => transaction_date,
     :opening_balance    => (opening_balance * 100).to_i, # Store amount as cents
     :ending_balance     => (ending_balance * 100).to_i,
     :transaction_amount => (transaction_amount * 100).to_i,
     :description        => description
    })
  end
end
