class Creditor < ActiveRecord::Base
  default_scope order('name')

  # === Validations
  validates_presence_of :name, :message => 'This field is required. Please enter a value.'
  validates_uniqueness_of :name, :message => 'This name already exists. Please enter another one.'

  # === Associations
  has_many :presets, :dependent => :destroy

  # Returns <tt>array</tt> in which the elements
  # with its id's included in <tt>first_ids</tt>
  # are listed first.
  # >> Creditor.checked_first(Creditor.all, [3, 6, 12])
  # => [#<Creditor id: 3, name: "Albert Heijn", ...>,
  #     #<Creditor id: 12, name: "Kabisa", ...>,
  #     #<Creditor id: 6, name: "Nettorama", ...>,
  #     #<Creditor id: 1, name: "Philips", ...>,
  #     ...]
  def self.checked_first(array, first_ids)
    return array unless first_ids
    creditors = array.select {|c| first_ids.include?(c.id)}

    (creditors + array).uniq
  end
end
