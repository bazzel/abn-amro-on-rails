class UploadDetail < ActiveRecord::Base
  # === Associations
  has_many :expenses, :dependent => :destroy
  belongs_to :upload

  # === Callbacks
  before_create :build_expense

  private
  def build_expense
    expenses.build({
     :bankaccount        => bankaccount,
     :transaction_date   => transaction_date,
     :opening_balance    => opening_balance,
     :ending_balance     => ending_balance,
     :transaction_amount => transaction_amount,
     :description        => description
    })
  end
end
