# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :preset do |f|
  f.sequence(:keyphrase) { |n| "Preset #{sprintf('%02d', n)}" }

  f.association :creditor
  f.category {|a| a.association(:subcategory) }
end
