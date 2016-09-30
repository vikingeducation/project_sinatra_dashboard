require 'rubygems'
require 'mechanize'
require 'csv'

class WebScraper

  attr_reader :data

  def initialize(job, city='Eugene OR')
    @scraper = Mechanize.new
    @scraper.history_added = Proc.new {sleep 0.5}
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
  end

  def search_query
    search_string = "/jobs?"
    search_string << "q=" + @job.split(' ').join('+')
    search_string << "&l=" + @city.split(' ').join('+')
    #search_string << "&=djtype" + @type.split(' ').join('+')
    #search_string << "&limit=10"
    search_string
  end

  def get_results
   @scraper.get("https://www.dice.com#{search_query}")
  end

  def job_links
    get_results.links.select do |link|
      /https:\/\/www.dice.com\/jobs\/detail/.match(link.href)
    end
  end

  def loop_through_job
    job_links.each do |link|
      object_page = @scraper.get(link.href)
      @job_title << object_page.search('h3 a').text
      @job_id << object_page.at('meta[name="jobId"]')[:content]
      @company_id << object_page.at('meta[name="groupId"]')[:content]
      @url << object_page.at('meta[property="og:url"]')[:content]
      @location << object_page.search('li.location').text
      @employer_name << object_page.search('li.employer').text
      @time_ago << date_parser(object_page.search('li.posted').text)
    end
  end

  def all_data
    @data = [@job_title, @employer_name, @location, @url,  @time_ago, @job_id, @company_id].transpose
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
    CSV.open('jobs.csv', 'w') do |csv|
      all_data.transpose.each do |row|
        csv << row
      end
    end
  end

end