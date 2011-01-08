# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :category do |f|
  f.sequence(:name) { |n| "Category #{sprintf('%02d', n)}" }
end

Factory.define :subcategory, :parent => :category do |f|
  f.parent {|a| a.association(:category) }
end