require 'nokogiri'
require 'open-uri'
require 'json'

# main scrapping program 
def scrapper(url)
  datas = []
  parsed_page = Nokogiri::HTML(URI.open(url)) #parsed page
  # for selecting the each cards
  job_listings = parsed_page.css('div.mb-10')
  # count the number of pages
  count = job_listings.count
  # coolect datas from each pages
  return job_listings,count,parsed_page
end

# scrape all datas wanted
def organize(job_listings)
  
  datas=[]
  for job in job_listings
    title = job.css("a").text
    description = job.css("div")[0].text
    page_link = job.css("a").attr("href")
    image_link = job.css("img").attr("src")
    second_data = page(page_link)
    date = second_data[0]
    paragraph = second_data[1]
    
    # create dictionary for each cards
    block = {
      "Title: " => title,
      "Description: " => description,
      "PageLink: " => page_link,
      "ImageLink: " => image_link,
      "Date: " => date,
      "Paragragh: " => paragraph,
    }
    # create list of dictionarie
    datas.push(block)
  end
  return datas
end
# second scrapper
def page(url)
  parsed_page = Nokogiri::HTML(URI.open(url))
  time = parsed_page.css('time')[0].text
  para = parsed_page.css('p')[0].text
  return time,para
end

# for writing the out file
def write(datas)
  formatted = JSON.pretty_generate(datas)
  File.write('./out.json', formatted)
end

def scrape2(page,n)
  datas = []
  count =0
  dynamic_page = ["https://www.freethink.com/articles?paging=","#more-stories"]
  parsed_page = page[2]
  job_listings = page[0]
  count += job_listings.count
  datas.push(organize(job_listings))
  n=n.to_i+1
  n.times do |i|
    puts "Collects data form page: " +i.to_s
    page = dynamic_page[0]+i.to_s+dynamic_page[1]
    scrap = scrapper(page)
    job_listings = scrap[0]
    count += job_listings.count
    datas.push(organize(job_listings))
  end
  write(datas)
  puts count.to_s+" no.of articles written on out.json file"
  n=n-1
  puts "All articles collected from "+n.to_s+" pages"
end
  
# find max available page number
def maxpage(parsed_page)
  page_numbers=parsed_page.css("a.page-numbers")
  allpages=[]
  page_numbers.each do |i|
    begin
      a = i.text
      allpages.push(a.to_i)
    rescue
      a=1
    end
  end
  return allpages.max
end
# main function to control thscrapper
def main()
  puts "Hi ,\n Explore the rubyscrapper program"
  puts "\nEnter the options \n1.Scrape data from home page[page:1] \n2.Scrape data form HomePage[1] to the n\n3.Scrape datas from all pages available"
  puts "Enter the option: "
  option = gets.chomp
  option = option.to_i
  if option == 1
    puts "Collecting data from the page:1 \nMay be it will take little time\nplease wait()..."
    page = 'https://www.freethink.com/articles'
    scrap = scrapper(page)
    job_listings = scrap[0]
    count = job_listings.count
    datas = organize(job_listings)
    write(datas)
    puts count.to_s+" no.of articles written on out.json file"
    
  elsif option == 2
    # scrape page contents for find page number
    page = 'https://www.freethink.com/articles' 
    page = scrapper(page)
    parsed_page = page[2]
    maxpage = maxpage(parsed_page)
    puts "\nWe are going Scrape data from page 1 to n"
    puts "The Maximun number of pages available:"+maxpage.to_s
    puts 'Enter the Page number: '
    n = gets.chomp
    if n.to_i ==1
      system ("clear")
      puts "Please try again with option no:1\n"
      sleep 2
      main
    else
      puts "Collecting data from the pages \nMay be it will take little time\nplease wait()..."
      scrape2(page,n)
    end
    
  elsif option ==3
    page = 'https://www.freethink.com/articles' 
    page = scrapper(page)
    parsed_page = page[2]
    n = maxpage(parsed_page)
    puts "Collecting data from all the pages \nit will take little time\nplease wait()..."
    scrape2(page,n)

  end

  
end
# page details
main()