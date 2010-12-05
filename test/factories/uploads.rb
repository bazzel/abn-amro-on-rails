# Read about factories at http://github.com/thoughtbot/factory_girl
require File.new(File.join(Rails.root, "spec/support", 'upload_helper.rb'))

Factory.define :upload do |f|
  f.tab upload_file('TXT101121100433.TAB')
end