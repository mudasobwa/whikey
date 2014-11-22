# encoding: utf-8

module Whikey
  class Parser
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
      @text = @text.gsub /\\n/, ' '
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
