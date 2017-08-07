require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'pry'

class Scraper

  def initialize(home_page_url, sleep_time=(rand(0..5)))
    @home = home_page_url
    @sleep_time = sleep_time
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
  end


  def get_home_page(url)
    home_page = @agent.get(url)
  end


  def basic_search(keywords, location)
    form = get_home_page(@home).form_with(:class => 'search-form')
    form.q = keywords
    form.l = location
    results = @agent.submit(form)
  end


  def filter_job_listings(options = {})
    job_links = search_with_params(options[:keywords], options[:location], options[:distance], options[:time_type]).search('.complete-serp-result-div')
    job_links.each do |r|
      job_details = job_post_details(r)
      save_job_post(job_details)
      delay(@sleep_time)
    end
  end


  private


  def search_with_params(keywords, location, distance, time)
    results = @agent.get("http://dice.com/jobs?q =#{keywords}&l=#{location}&djtype=#{time}&radius-#{distance}-jobs")
  end


  def job_post_details(individual_post)
    job_post_page = @agent.click(individual_post.at('h3 a'))
    job_title = find_details('h1#jt.jobTitle', job_post_page)
    company_name = find_details('li.employer', job_post_page).chomp(",")
    location = find_details('li.location', job_post_page)
    posting_date = job_date(job_post_page)
    job_url = job_post_page.uri
    details = { :co_name => company_name, :title => job_title, :l => location, :date => posting_date, :url => job_url }
  end


  def find_details(css, page)
    details = page.at(css).text.strip
  end


  def job_date(job_post_page)
    posted_at = job_post_page.at('li.posted.hidden-xs').text.strip
    time_unit = posted_at.split(" ")[2]
    time_unit += "s" unless time_unit[-1] == "s"
    amount = posted_at.split(" ")[1].to_i unless posted_at.split(" ")[1] == "moments"
    change_to_seconds = { "moments" => 30,
                          "minutes" => amount * 60,
                          "hours" => amount * 3600,
                          "days" => amount * 86400,
                          "weeks" => amount * 86400 * 7,
                          "months" => amount * 86400 * 30
                        } unless amount.nil?
    time_in_seconds = change_to_seconds[time_unit]
    date_posted = Time.now - time_in_seconds
    "#{date_posted.month}/#{date_posted.day}/#{date_posted.year}"
  end


  def get_text(string, page)
    page.search("div.company-header-info div.row div.col-md-12").each do |n|
      @text_string = n.text.strip if n.text.include?(string)
    end
    @text_string
  end


  def save_job_post(options = {})
    headers = [ "Company Name", "Job Title", "Location", "Date Posted", "Job Posting URL"]
    CSV.open('jobs.csv', 'a+') do |csv|
      csv << headers if csv.count.eql? 0
      csv << options.values
    end
  end


  def delay(seconds)
    sleep_delay = rand(seconds)
    sleep(sleep_delay)
  end

end
