# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :upload do |f|
  f.xls File.new(File.join(Rails.root, "spec/fixtures/upload", 'XLS101121100457.xls'))
end