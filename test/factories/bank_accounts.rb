# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :bank_account do |f|
  f.sequence(:account_number) { |n| sprintf('%09d', n) }
  
  f.description "MyString"
end
