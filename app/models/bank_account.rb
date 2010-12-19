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

  def balance
    expenses.empty? ? 0 : expenses.order('expenses.id').last.balance
  end
  
  # [
  #   {
  #     "bank_account" : {
  #       "account_number" : "861887719",
  #       "created_at"     : "2010-12-05T09:53:24Z",
  #       "description"    : "a la carte",
  #       "id"             : 1,
  #       "updated_at"     : "2010-12-08T13:49:36Z",
  #       "balance"        : "0.0"
  #     }
  #   },
  #   {
  #     "bank_account" : {
  #       "account_number" : "972259171",
  #       "created_at"     : "2010-12-05T09:53:40Z",
  #       "description"    : null,
  #       "id"             : 2,
  #       "updated_at"     : "2010-12-08T13:49:40Z",
  #       "balance"        : "152.24"
  #     }
  #   },
  #   ...
  # ]
  def as_json(options = nil)
    super(:methods => [:balance])
  end
end

# $.getJSON('http://localhost:3000/bank_accounts.json', function(data) {
#   $.each(data, function(index, value) {
#     console.log(value.bank_account.balance);
#   });
# });