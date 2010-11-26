module Parsers
  class TabParser
    class << self
      def foreach(path)
        # Read headers
        # Loop through rows
        # and
        
        3.times do |row|
          # yield(row) if block_given?
          yield(row) if block_given?
        end
      end
    end
  end
end
