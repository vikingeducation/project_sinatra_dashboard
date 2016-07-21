# web_scraper.rb

require 'rubygems'
require 'mechanize'
require 'csv'

class WebScraper

  attr_reader :mech, :job_title, :job_id, :company_id, :url, :location, :employer_name, :time_ago, :data

  def initialize
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
  end

  def get_job
    job = gets.chomp
    job.split(" ").join("+")
  end

  def get_location
    location = gets.chomp
    location.split(" ").join("+")
  end

  def get_job_type
    job_type = gets.chomp
    job_type.split(" ").join("+")
  end

  def search_query
    jobs = ["Javascript", "Ruby", "Bartender"]
    cities = ["New+York%2C+NY", "San+Francisco%2C+CA", "Miami%2C+FL"]
    job_types = ["Full+Time", "Part+Time", "Contracts"]
    search_string = ""
    search_string << "/jobs?"
    search_string << "q=" + jobs[0]
    search_string << "&l=" + cities[0]
    search_string << "&=djtype" + job_types[0]
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

web_scraper = WebScraper.new
web_scraper.loop_through_job_links
web_scraper.write_csv
# web_scraper = WebScraper.new
# results =  web_scraper.get_results.links_with(:href => %r{/jobs/})


