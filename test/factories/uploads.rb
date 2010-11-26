# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :upload do |f|
  f.tab File.new(File.join(Rails.root, "spec/fixtures/upload", 'TXT101121100433.TAB'))
end