# This module is used to extend ActiveRecord::Base
# see config/initializers/core_extensions.rb
module Sortable
  # Returns <tt>array</tt> in which the elements
  # with its id's included in <tt>first_ids</tt>
  # are listed first.
  # >> Creditor.prioritized(Creditor.all, [3, 6, 12])
  # => [#<Creditor id: 3, name: "Albert Heijn", ...>,
  #     #<Creditor id: 12, name: "Kabisa", ...>,
  #     #<Creditor id: 6, name: "Nettorama", ...>,
  #     #<Creditor id: 1, name: "Philips", ...>,
  #     ...]
  def prioritized(array, first_ids)
    return array unless first_ids
    priorities = array.select {|c| first_ids.include?(c.id)}

    (priorities + array).uniq
  end

end