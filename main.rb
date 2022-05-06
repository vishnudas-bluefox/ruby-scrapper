require 'httparty'
require 'nokogiri'
require 'open-uri'


def scrapper
  url="https://www.freethink.com/articles"
  unparsed_page = HTTParty.get(url)
  parsed_page =Nokogiri::HTML(unparsed_page)
  job_listings =parsed_page.css('div.mb-10')
  count = job_listings.count
  puts "\n\n\n\n"
  first_job = job_listings.first
  puts "\n\n\n\n"

  puts first_job
  title = first_job.xpath('//div//div//div//a')
  puts "\n\n\n\n"

  puts title.content
end

scrapper