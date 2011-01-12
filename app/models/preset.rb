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

  # Apply preset to given expenses
  def apply_to(expenses)
    matches = expenses.select { |e| e.description.match(/#{keyphrase}/)}

    Expense.update_all({
      :category_id => category_id,
      :creditor_id => creditor_id
    }, {
      :id => matches.map(&:id)
    }) unless matches.empty?

    return matches
  end

  class << self
    # Apply all presets to given expenses
    def apply_to(expenses)
      apply(all, expenses)
    end

    # Apply given presets to all expenses
    def apply_for(presets)
      apply(presets, Expense.all)
    end

    # Apply given presets to given expenses
    def apply(presets, expenses)
      num_applied = 0

      presets.each do |preset|
        matches = preset.apply_to(expenses)
        num_applied = num_applied + matches.size
        expenses = expenses - matches
      end

      num_applied
    end
  end
end
