# encoding: utf-8

require_relative 'parsers/infobox.rb'

module Whikey
  class Parser
    COMMENT = /\s*<!--(.*?)-->\s*/m
    ENTITY = /(?<match>\{\{((\g<match>|[^\{\}]*))*\}\})/m
    SUBENTITY = /\{\{(\s*(?<key>\w+)\s*\|\s*(?<value>[^=\{\}]*)+)\}\}/m

    ENTITIES = {
      :geolocation => {
        :full => /((((lat|long)(d|m|s|NS|EW))\s*=.*?\|\s*){8})/m,
        :partial => /\s*(\w+)\s*=\s*(\w*)\s*\|/m
      },
      :infobox => {
        :full => /{{Infobox }}/
      }
    }

    def initialize term, lang = :en
      require 'json'
      @text = Crawler.new(term, lang).content
      @text = @text.gsub COMMENT, ' '
      @text.scan(ENTITY) { |item|
        item[0].scan(/\A\{\{(\w+)\s+(\w+).*\}\}\Z/m) { |atom|
          if(Class::const_get())
          puts '*'*40
puts $~[1]
puts $~[2]
        }
      }
    end

    def atom input

    end

    def method_missing method, *args, &cb
      return super unless ENTITIES.has_key? method
      return ENTITIES[method][:result] if ENTITIES[method][:result]

      ENTITIES[method][:result] = {}
      @text.scan(ENTITIES[method][:full]) { |loc|
        loc[0].scan(ENTITIES[method][:partial]) { |ent|
          ENTITIES[method][:result][ent.first] = ent.last
        }
      }
      ENTITIES[method][:result]
    end
  end
end
