class Creditor < ActiveRecord::Base
  default_scope order('name')

  # === Validations
  validates_presence_of :name, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :name, :message => 'This name already exist. Please enter another one.'

end
