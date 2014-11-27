# encoding: utf-8

###############################################################################
####    GIVEN
###############################################################################

Given(/^we have a term "(.*?)"$/) do |term|
  @term = term
end

###############################################################################
#####    WHEN
###############################################################################

When(/^we retrieve the content from remote$/) do
  @wiki = Whikey::Crawler.new(@term).retrieve
end

When(/^we initialize 'Parser' with this term$/) do
  @parser = Whikey::Parsers.handle(@term)['Infobox'].first
end

When(/^we request "(.*?)" tag from parser$/) do |tag|
  @output = @parser.send "#{tag}"
end

###############################################################################
#####    THEN
###############################################################################

Then(/^the result is stored in cache folder$/) do
  raise Exception.new("File [#{@wiki.local}] was not created") unless File.exists? @wiki.local
end

Then(/^the result equals to "(.*?)"$/) do |result|
  expect(@output.to_s).to eq(result)
end
