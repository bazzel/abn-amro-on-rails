# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :expense do |f|
  f.transaction_date Date.today
  f.opening_balance 123.45
  f.ending_balance 234.56
  f.transaction_amount 345.67
  f.description 'Lorem ipsum'
  f.association :upload_detail
  f.balance 469.12
  f.association :bank_account
end
