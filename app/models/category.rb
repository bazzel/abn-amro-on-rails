class Category < ActiveRecord::Base
  acts_as_tree :order => "name"

  # === Validations
  validates_presence_of :name, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :name, :scope => :parent_id, :message => 'This name already exist. Please enter another one.'

  # === Associations
  has_many :expenses, :dependent => :nullify

  # === Scopes
  scope :children, where(['parent_id IS NOT ?', nil]).order(:name)

end
