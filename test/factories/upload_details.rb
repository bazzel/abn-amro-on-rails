# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :upload_detail do |f|
  f.bankaccount '861887719'
  f.transaction_date Date.today
  f.opening_balance 123.45
  f.ending_balance 234.56
  f.transaction_amount 345.67
  f.description 'Lorem ipsum'
end
