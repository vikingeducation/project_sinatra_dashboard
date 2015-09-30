require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'csv'

Result = Struct.new(:job_title, :company_name, :link, :location, :post_date, :company_id, :job_id)

class Scraper 
  attr_accessor :html_tree, :params, :results
  def initialize
    @results = []
  end

  # change params to an options hash
  def scrape(uri, query, location)
    agent = Mechanize.new
    page = agent.get(uri)
    search_form = page.form_with(:action => '/jobs')
    search_form.q = query
    search_form.l = location
    search_results = search_form.submit

    search_results.links_with(:href => /\/detail/).each do |link|
      link_page = link.click
      job_title = link_page.search("h1.jobTitle").text
      company_name = link_page.search("li.employer a").text
      link = link.uri.to_s
      location = link_page.search("li.location").text
      post_date = link_page.search("title").text[-21..-12] #hardcode
      company_id = link_page.search("div.company-header-info div div:contains('Dice Id')").text[10..-1]
      job_id = link_page.search("div.company-header-info div div:contains('Position Id')").text[14..-1]    
    
      r = Result.new(job_title, company_name, link, location, post_date, company_id, job_id)
      @results << r
    end
  end

  def results_to_s
    s = ""
    @results.each do |result|
      s += "--- JOB ---\n"
      result.each do |attribute|
        s += "#{attribute}\n"
      end
      s += "\n"
    end
    s
  end

  def results
    @results
  end

  def save_results(filename)
    CSV.open('../#{filename}', 'a') do |csv|
      @results.each do |result|
        csv << result
      end
    end
  end
end

#mechanize#parse vs mechanize::page#parser?

# scraper = Scraper.new

# uri = "http://dice.com"
# query = "ruby"
# location = "San Francisco, CA"

# scraper.scrape(uri, query, location)
# # scraper.render_results
# scraper.save_results("results.csv")