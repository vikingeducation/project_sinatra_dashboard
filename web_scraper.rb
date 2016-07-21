# web_scraper.rb

require 'rubygems'
require 'mechanize'
require 'csv'
require 'uri'

class WebScraper

  def initialize(job, city, type)
    @mech = Mechanize.new
    @mech.history_added = Proc.new {sleep 0.5}
    @job_title = []
    @job_id = []
    @url = []
    @location = []
    @employer_name = []
    @time_ago = []
    @company_id = []
    @data = nil
    @job = job
    @city = city
    @type = type
  end

  def search_query
    search_string = ""
    search_string << "/jobs?"
    search_string << "q=" + @job.split(' ').join('+')
    search_string << "&l=" + @city.split(' ').join('+')
    search_string << "&=djtype" + @type.split(' ').join('+')
    search_string
  end

  def get_results
    @mech.get("https://www.dice.com#{search_query}")
  end

  def job_links
    get_results.links.select do |link|
      /https:\/\/www.dice.com\/jobs\/detail/.match(link.href)
    end
  end

  def loop_through_job_links
    job_links.each do |link|
      object_page = @mech.get(link.href)
      @job_title << object_page.search(".jobTitle").text
      @job_id << object_page.at('meta[name="jobId"]')[:content]
      @company_id << object_page.at('meta[name="groupId"]')[:content]
      @url << object_page.at('meta[property="og:url"]')[:content]
      @location << object_page.search(".location").text[0..-1]
      @employer_name << object_page.search(".employer").text.strip[0..-2]
      @time_ago << date_parser(object_page.search(".posted").text)
    end
  end

  def all_data 
    @data = [@job_title, @job_id, @company_id, @url, @location, @employer_name, @time_ago]
  end

  def date_parser(date)
    units = date.match(/(moment|minute|hour|day|week|month)/)[0]
    number = date.match(/\d+/)[0].to_i
    result = case units
    when "moment"
      0
    when "minute"
      number * 60
    when "hour"
      number * 3600
    when "day"
      number * 86_400
    when "week"
      number * 86_400 * 7
    when "month"
      number * 86_400 * 30
    end

    "Posted around #{Time.now - result}"
  end

  def write_csv
    CSV.open("text.csv", "w") do |csv|
      all_data.transpose.each do |posting|
        csv << posting
        csv << [nil]
      end
    end
  end

end
web_scraper = WebScraper.new("ruby", "new york", "full time")
web_scraper.loop_through_job_links
web_scraper.write_csv
# web_scraper = WebScraper.new
# results =  web_scraper.get_results.links_with(:href => %r{/jobs/})


