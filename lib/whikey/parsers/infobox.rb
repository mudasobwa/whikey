# encoding: utf-8

require 'awesome_print'
require 'itudes'

require_relative 'generic.rb'

module Whikey
  module Parsers
    class Infobox < Generic
#        :geolocation => /((((lat|long)(d|m|s|NS|EW))\s*=.*?\|\s*){8})/m,

      def initialize name, data
        super
        data.gsub! Parsers::COMMENT, "\n"
        data.gsub! Parsers::LINK, '☆\k<title> ⇒ \k<link>★'
        data.gsub! Parsers::SUBENTITY, '☏\k<type> → \k<name> ⇒ \k<content>☎'
        data.scan(Parsers::VALUE) { |mtch|
          self.set mtch
        }
      end

      def geo
        Geo::Itudes.new(
          "#{self.latd || 0}°#{self.latm || 0}′#{self.lats || 0}″#{self.latNS || 'S'}",
          "#{self.longd || 0}°#{self.longm || 0}′#{self.longs || 0}″#{self.longEW || 'W'}"
        )
      end

    end
  end
end
