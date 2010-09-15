require 'ostruct'
module ActiveRecord
  class Base
    class << self
      def insert(query)
        connection.insert(query)
      end
      def delete(query)
        connection.delete(query)
      end
      def execute(query)
        connection.execute(query)
      end
      def select_all(query)
        rows = connection.select_all(query)
        rows.map! do |row|
          row = OpenStruct.new(row)
          table = row.send(:table)
          table.each {|k, v| table[k] = select_type_cast(v) }
          row
        end
        rows
      end
      def select_one(query)
        select_all(query).first
      end
      def select_value(query)
        select_type_cast(connection.select_value(query))
      end
      def select_type_cast(v)
        return unless v
        if md = v.match(/^(\d{4})-(\d{2})-(\d{2})$/)
          Date.new(*md.captures.map(&:to_i)) rescue v
        elsif md = v.match(/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/)
          Time.local(*md.captures.map(&:to_i)) rescue v
        elsif v =~ /^\d+$/
          v.to_i
        elsif v =~ /^\d+(?:\.\d+)+$/
          v.to_f
        else
          v
        end
      end
    end
  end
end