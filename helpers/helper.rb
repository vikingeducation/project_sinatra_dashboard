
require_relative 'web_scrapper.rb'
require 'rubygems'
require 'mechanize'


module JobHuntHelper
  include JobScrapper

  def all_jobs(city="Galway", keyword="ruby", company="", date="", ip = "::1")
    WebScrapper.new.parse_all_job_adverts(city, keyword, company, date, ip)
  end

end