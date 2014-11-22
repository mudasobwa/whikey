# encoding: utf-8

require 'open-uri'
require 'digest/md5'
require 'fileutils'
require 'json'

module Whikey
  class Crawler
    LOCAL = '.cache'
    attr_reader :uri, :content

    def initialize term, lang = :en
      @term = term
      @lang = "#{lang}"
      @uri  = "http://#{@lang}.wikipedia.org/w/api.php?format=json&action=query&titles=#{URI::encode @term}&prop=revisions&rvprop=content&continue="
      @dir  = File.join LOCAL, "#{@lang}"
      @file = "#{URI::encode @term}.json"

      retrieve
    end

    def local
      File.join @dir, @file
    end

    def self.json uri
      JSON.parse URI::parse(uri).read
    end

    def follow uri
      while true
        json = Crawler::json uri
        content = json['query']['pages'].first.last['revisions'].first['*']
        break content unless content =~ /^\#REDIRECT\s+\[\[(.*)\]\]$/
        uri = $~[1]
      end
    end

    def retrieve force = false
      @content = File.read(local) if File.exists?(local)
      return self unless force || !@content

      @content ||= follow @uri
      md5 = Digest::MD5.hexdigest @content
      file = "#{URI::encode @term}.#{md5}.json"
      return self unless force || !File.exists?(File.join @dir, file)

      FileUtils.mkpath(@dir) unless File.exists?(@dir)
      FileUtils.cd(@dir) do
        File.open(file, 'w') { |file| file.write(@content) }
        File.delete(@file) if File.exists?(@file)
        File.symlink(file, @file) rescue FileUtils.cp(file, link) # f★ck win
      end

      self
    end
  end
end
