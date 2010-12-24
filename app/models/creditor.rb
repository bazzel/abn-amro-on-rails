class Creditor < ActiveRecord::Base
  default_scope order('name')
end
