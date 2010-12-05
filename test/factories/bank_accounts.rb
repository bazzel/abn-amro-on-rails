# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :bank_account do |f|
  f.account_number "MyString"
  f.description "MyString"
end
