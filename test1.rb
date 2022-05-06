require 'nokogiri'
require 'open-uri'
require 'json'


def scrapper(url)
  datas = []
  parsed_page = Nokogiri::HTML(URI.open(url))
  job_listings = parsed_page.css('div.mb-10')
  count = job_listings.count
  first_job = job_listings.first
  for job in job_listings
    title = job.css("a").text
    description = job.css("div")[0].text
    page_link = job.css("a").attr("href")
    image_link = job.css("img").attr("src")
    second_data = page(page_link)
    date = second_data[0]
    paragraph = second_data[1]
    block = {
      "Title: " => title,
      "Description: " => description,
      "PageLink: " => page_link,
      "ImageLink: " => image_link,
      "Date: " => date,
      "Paragragh: " => paragraph,
    }
    datas.push(block)
    # block.each do |key,value|
    #   puts key+"  "+value
    # end
  end
  puts JSON.pretty_generate(datas)
end

def page(url)
  parsed_page = Nokogiri::HTML(URI.open(url))
  time = parsed_page.css('time')[0].text
  para = parsed_page.css('p')[0].text
  return time,para
end
page = 'https://www.freethink.com/articles'
scrapper(page)