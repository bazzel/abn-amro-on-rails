class BankAccount < ActiveRecord::Base
  # === Associations
  has_many :expenses

  # === Validations
  validates_presence_of :account_number, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :account_number, :message => 'This account number already exist. Please enter another one.'

  def to_s
    account_number.gsub(/(\d{2})(\d{2})(\d{2})(\d{3})/, '\1.\2.\3.\4')
  end

end
