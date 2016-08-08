require_relative "../jobs_scraper.rb"
require 'mechanize'
module JobHelper
  def get_jobs(search_text, days)
    JobScraper.new.get(search_text, session[:city] ,days)
  end

end

module GeoLocation
  def location(ip)
    uri = "http://freegeoip.net/json/#{ip}"
    agent = Mechanize.new
    agent.get(uri)
  end

end