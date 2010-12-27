# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :creditor do |f|
  f.sequence(:name) { |n| "Creditor #{sprintf('%02d', n)}" }
end
