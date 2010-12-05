class BankAccount < ActiveRecord::Base
  # === Associations
  has_many :expenses

end
