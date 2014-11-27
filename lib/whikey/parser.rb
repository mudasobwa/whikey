# encoding: utf-8

require_relative 'parsers/generic.rb'
require_relative 'parsers/infobox.rb'

module Whikey
  module Parsers
    COMMENT = /\s*<!--(.*?)-->\s*/m
    ENTITIES = /(?<match>{{((\g<match>|[^{}]*))*}})/m # Till matched curly brackets
    ENTITY = /{{(?<type>[\w\-]+)\s*(?<name>[^|]*)\|(?<content>.*)}}/m
    SUBENTITY = /{{(?<title>[^|{}]+)\|(?<content>[^{}]*)}}/m
    LINK = /\[\[(?<title>[^|\[\]]*)\|(?<link>[^\[\]]*)\]\]/m
    VALUE = /(?<=\A|\|)(?<key>[^=]+)=(?<value>[^|]*)(?=\Z|\|)/m

    def self.handle term, lang = :en
      require 'json'
      content = {}
      text = Crawler.new(term, lang).content
      text.scan(ENTITIES) { |item|
        type, name, data = ENTITY.match(item.first) do |mtch|
          [mtch['type'], mtch['name'], mtch['content']].map(&:strip)
        end
        next if type.nil? || type.empty?
        data.gsub! SUBENTITY, '❴\k<title>¦\k<content>❵'
        data.gsub! LINK, '⦃\k<title>¦\k<link>⦄'
        clazz = begin
                  Object::const_get("Whikey::Parsers::#{type}")
                rescue NameError
                  next
                  Object::const_get("Whikey::Parsers::Generic")
                end
        (content[type] ||= []) << clazz.new(name, data)
      }
      content
    end

  end
end
