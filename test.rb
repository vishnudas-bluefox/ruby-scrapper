
require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
doc = Nokogiri::HTML(URI.open('https://www.freethink.com/articles'))

# Search for nodes by css
puts "css\n ==============================="
doc.css('nav ul.menu li a', 'article h2').each do |link|


  puts link.content
end

# Search for nodes by xpath
puts "xpath \n====================================="
doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
  
  puts link.content
end

# Or mix and match
doc.search('nav ul.menu li a', '//article//h2').each do |link|
  puts link.content
end