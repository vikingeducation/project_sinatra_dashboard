require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceWebScraper
  attr_reader :jobs 
  def initialize(query, zip, radius, num_results)
    @agent = Mechanize.new
    @jobs = search_jobs(query, zip, radius, num_results)
  end

  # assume search_query is a string: 'hi i am a string', zip is '#####' (string) 
  # radius is a number... 5, 10, 20, 30 (default), 40, 50 ,75, 100
  # num_results is the number of jobs found to save to file (default: 30, one page)
  def search_jobs(search_query, zip, radius = 30, num_results = 30) 
    url = generate_url(search_query, zip, radius)
    page = @agent.get(url)
    jobs = page.search('div.complete-serp-result-div')
    all_jobs = []
    jobs.each do |job|
      job_hash = {}
      job_hash['title'] = job.search('li h3').text.strip
      job_hash['company'] = job.search('li.employer span.hidden-xs').text
      job_hash['link'] = job.search('li h3 a')[0].attributes['href'].value
      job_hash['location'] = job.search('li.location').text
      job_hash['posted_relative'] = job.search('li.posted').text
      # post_date
      company_id_link = job.search('div.logopath a')[0].attributes['href'].value
      job_hash['company_id'] = extract_cid_from_link(company_id_link)
      job_hash['job_id'] = extract_jid_from_link(job_hash['company_id'], job_hash['link'])
      all_jobs << job_hash
    end
    all_jobs
  end

  private

  def extract_cid_from_link(company_id_link)
    company_id_link.sub('https://www.dice.com/company/','')
  end 

  def extract_jid_from_link(company_id, job_link)
    job_link.match(/.*?#{company_id}\/(.*?)[?]/).captures[0]
  end

  def generate_url(search_query, zip, radius)
    url = 'https://www.dice.com/jobs'
    # default radius is 30 miles
    if radius == 30
      url += "?q=#{search_query.gsub(' ', '+')}"
      url += "&l=#{zip.to_s}"
    else
      url += "/q-#{search_query.gsub(' ', '_')}-limit-30-"
      url += "l-#{zip}-"
      url += "radius-#{radius.to_s}-jobs.html"
    end
    url
  end
end