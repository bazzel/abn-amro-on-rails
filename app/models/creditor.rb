class Creditor < ActiveRecord::Base
  default_scope order('name')

  # === Validations
  validates_presence_of :name, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :name, :message => 'This name already exists. Please enter another one.'

  # === Associations
  has_many :presets, :dependent => :destroy

  def self.checked_first(checked)
    return all unless checked
    checked_creditors = all.select {|c| checked.include?(c.id)}

    (checked_creditors + all).uniq
  end
end
