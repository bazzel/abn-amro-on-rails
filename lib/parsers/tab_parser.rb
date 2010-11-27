module Parsers
  
  module Hashable
    # Collapses the array into a simple Hash.
    #  ['8611876719', 'EUR', ...].to_hash
    #  # => {
    #    :bankaccount => '861887719',
    #    :valuta      => 'EUR',
    #    ...
    #  }
    def to_hash
      keys = [:bankaccount, 
              :valuta, 
              :date_of_transaction, 
              :start_balance,
              :end_balance,
              :date_of_interest,
              :amount,
              :description]
      Hash[*keys.zip(self).flatten]
    end
  end

  class TabParser
    class << self
      def foreach(path)
        options = {
          :col_sep => "\t",
          :converters => converters
        }
        CSV.foreach(path, options) do |row|
          # row is an Array, but we extend it
          # so we can call the to_hash method
          # on it. 
          row.extend Hashable
          yield(row) if block_given?
        end
      end
      
      private
      def converters
        Proc.new do |v|
          case v
          when bankaccount  then v
          when date         then Date.parse(v)
          when amount       then v.gsub(',','.').to_f
          else                   v.strip
          end
        end
      end

      def bankaccount
        /^\d{9}$/
      end

      def date
        /^(19|20)\d\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/
      end

      def amount
        /^-?\d+,\d{2}$/
      end
    end
  end
end
