class Category < ActiveRecord::Base
  acts_as_tree :order => "name"

  # === Validations
  validates_presence_of :name, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :name, :scope => :parent_id, :message => 'This name already exists. Please enter another one.'

  # === Associations
  has_many :expenses, :dependent => :nullify

  # === Scopes
  scope :children, where(['parent_id IS NOT ?', nil]).order(:name)

  # Returns sum of all incomes.
  def credit
    @credit ||= begin
      @credit = if parent
        expenses.credit.sum(:transaction_amount)
      else
        children.inject(0) { |total, child| total += child.credit }
      end
    end
  end

  # Returns sum of all outgoing.
  def debit
    @debit ||= begin
      @debit = if parent
        expenses.debit.sum(:transaction_amount)
      else
        children.inject(0) { |total, child| total += child.debit }
      end
    end
  end

  def total
    @total ||= credit + debit
  end

  class << self
    # Returns the value of the Category with the largest credit or debit
    # (negative values included!).
    def max(roots = nil)
      @max ||= begin
        collection = roots ? self.roots : self.children
        @max = collection.inject(0) do |max, category|
          [category.credit, category.debit.abs, max].max
        end
      end
    end
  end
end
