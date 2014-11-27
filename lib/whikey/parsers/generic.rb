# encoding: utf-8

module Whikey
  module Parsers
    class Generic
      attr_reader :hash

      def initialize name, data
        @hash = {}
      end

      def to_s
        @hash.to_s
      end

      def inspect
        @hash.inspect
      end

    protected

      def set key_val
        value = key_val.last.strip
        value = case value
                when ->(x) { x.empty? } then nil
                when value.to_i.to_s then value.to_i
                when value.to_f.to_s then value.to_f
                else value
                end
        @hash[key_val.first.strip.to_sym] = value
      end

      def method_missing method, *args, &cb
        @hash.has_key?(method) ? @hash[method] : super
      end
    end
  end
end
