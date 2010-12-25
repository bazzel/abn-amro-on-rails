class Category < ActiveRecord::Base
  acts_as_tree :order => "name"

  scope :children, where(['parent_id IS NOT ?', nil]).order(:name)

end
