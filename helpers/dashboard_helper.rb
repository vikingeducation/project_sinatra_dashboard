require 'httparty'
require_relative 'scraper'
require_relative 'company_profiler'

module DashboardHelper

  def get_location(ip)
    url = "https://freegeoip.net/json/#{ip}"
    location = HTTParty.get(url)["zip_code"]
  end

  def random_ip_generator
    Array.new(4){rand(256)}.join('.')
  end

  def save_sessions(location)
    session[:location] = location
  end

  def load_location
    session[:location]
  end

  def conduct_search(search_terms, location)
    Scraper.new(search_terms, location).postings
  end

  def company_profiles(postings, ip, user_agent)
    postings.map {|job| CompanyProfiler.new(job.company, ip,user_agent)} 
  end

end