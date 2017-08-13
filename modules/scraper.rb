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
    job_links = search_with_params(options[:keywords], options[:location], options[:distance], options[:time_type]).parser.xpath('//div[@class="complete-serp-result-div"]')
    if job_links.nil?
      save_no_jobs
    else
      details = job_post_details(job_links)
      save_job_post(details)
    end
  end


  private


  def search_with_params(keywords, location, distance, time)
    results = @agent.get("http://dice.com/jobs?q=#{keywords}&l=#{location}&djtype=#{time}&radius-#{distance}-jobs")
  end


  def job_post_details(page)
    company_name = find_info(page, '//span[@itemprop="name"]')
    job_title = find_info(page,'//span[@itemprop="title"]/text()')
    location = find_info(page, '//span[@itemprop="addressLocality"]/text()')
    posting_date = find_posting_date(page)
    job_url = find_job_url(page)
    details = { :co_name => company_name, :title => job_title, :l => location, :date => posting_date, :url => job_url }
  end


  def find_info(page,css)
    info = []
    page.search(css).each do |x|
      info << x.text
    end
    info
  end


  def find_posting_date(page)
    posting_date = []
    page.search('div ul li.posted').each do |time|
      posting_date << time.text
    end
    posting_date.map! {|time| job_date(time)}
  end


  def find_job_url(page)
    job_url = []
    page.search("//a[@itemprop='url']").each do |url|
      job_url << url.attr('href')
    end
    job_url
  end


  def find_details(tag, page)
    details = page.css(tag).text.strip
  end


  def job_date(posted_at)
    posted_array = posted_at.split(" ")
    amount = posted_array[0].to_i unless posted_array == "moments"
    time_unit = nil
    if posted_array[0] == "moments"
      time_unit = posted_array[0]
    else
      time_unit = posted_array[1]
    end
    time_to_date(time_unit, amount)
  end


  def time_to_date(time_unit, amount)
    time_unit += "s" unless time_unit[-1] == "s"
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
    puts "#{@text_string}"
    @text_string
  end


  def save_job_post(options = {})
    headers = [ "Job Title", "Company Name", "Location", "Date Posted", "Job Posting URL"]
    CSV.open('jobs.csv', 'w+') do |csv|
      csv << headers if csv.count.eql? 0
      # csv << options.values
      30.times do |i|
        csv << [options[:title][i], options[:co_name][i], options[:l][i], options[:date][i], options[:url][i]]
      end
    end
  end


  def save_no_jobs
    CSV.open('jobs.csv', 'w+') do |csv|
      csv << ["NO JOBS FOUND"]
    end
  end


  def delay(seconds)
    sleep_delay = rand(seconds)
    sleep(sleep_delay)
  end

end
