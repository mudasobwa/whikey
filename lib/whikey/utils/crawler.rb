# encoding: utf-8

require 'open-uri'
require 'digest/md5'
require 'fileutils'
require 'json'

module Whikey
  class Crawler
    LOCAL = '.cache'
    attr_reader :content

    def initialize term, lang = :en
      @term, @lang, @dir = term, lang, File.join(LOCAL, "#{lang}")

      retrieve
    end

    def uri
      "http://#{@lang}.wikipedia.org/w/api.php?format=json&action=query&titles=#{URI::encode @term}&prop=revisions&rvprop=content&continue="
    end

    def local
      File.join @dir, "#{URI::encode @term}.json"
    end

    def retrieve force = false
      @content = File.read(local) if File.exists?(local)
      return self unless force || !@content

      @content ||= follow
      md5 = Digest::MD5.hexdigest @content
      file = "#{URI::encode @term}.#{md5}.json"
      return self unless force || !File.exists?(File.join @dir, file)

      FileUtils.mkpath(@dir) unless File.exists?(@dir)
      FileUtils.cd(@dir) do
        File.open(file, 'w') { |file| file.write(@content) }
        target = "#{URI::encode @term}.json"
        File.delete(target) if File.exists?(target)
        File.symlink(file, target) rescue FileUtils.cp(file, link) # f★ck win
      end

      self
    end

    def follow # :nodoc:
      while true
        json = JSON.parse URI::parse(uri).read
        content = json['query']['pages'].first.last['revisions'].first['*']
        break content unless content =~ /^\#REDIRECT\s+\[\[(.*)\]\]$/
        @term = $~[1]
      end
    end
    private :follow

  end
end
