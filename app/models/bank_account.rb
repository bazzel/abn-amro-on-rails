class BankAccount < ActiveRecord::Base
  # === Associations
  has_many :expenses

  # === Validations
  validates_presence_of :account_number, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :account_number, :message => 'This account number already exist. Please enter another one.'

  # Returns a formatted account number
  # => 86.18.87.719
  def to_s
    account_number.gsub(/(\d{2})(\d{2})(\d{2})(\d{3})/, '\1.\2.\3.\4')
  end
  
  def account_number=(new_account_number)
    write_attribute(:account_number, account_number || new_account_number)
  end

end
