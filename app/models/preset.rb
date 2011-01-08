class Preset < ActiveRecord::Base

  # === Validations
  validates_presence_of :keyphrase, :message => 'This field is required. Please enter a value.'
  validates_presence_of :creditor, :message => 'This field is required. Please enter a value.'
  validates_presence_of :category, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :keyphrase, :message => 'This keyphrase already exists. Please enter another one.'

  # == Associations
  belongs_to :category
  belongs_to :creditor

  attr_accessor :creditor_name

  def creditor_name=(name)
    self.creditor = Creditor.find_or_create_by_name(name) unless name.blank?
  end

end
